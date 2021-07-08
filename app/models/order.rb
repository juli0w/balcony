class Order < ApplicationRecord
  has_many :order_items,  dependent: :destroy
  has_many :order_tintas, dependent: :destroy
  has_many :order_inks, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :client, optional: true

  has_many :items, through: :order_items
  # delegate :items, :to => :order_items, :allow_nil => true

  # default_scope { where("orders.created_at > ?", 1.day.ago) }

  scope :digital, -> { where(digital: true) }

  scope :opened, -> { where(state: "open") }
  scope :pending, -> { where(state: "pending") }
  scope :paid, -> { where(state: "paid") }
  scope :quote, -> { where(state: "quote") }
  scope :canceled, -> { where(state: "canceled") }
  scope :opened_and_quote, -> { where("state = ? or state = ? or state = ?", "open", "quote", "pending") }
  scope :boletos, -> { where(boleto: true) }
  scope :pix, -> { where(pix: true) }
  scope :not_empty, -> { where.not(state: "") }
  scope :not_db, -> { where.not(user_id: 33) }

  include SearchCop

  search_scope :search do
    attributes :id
    attributes :state
    attributes :seller
    attributes :user => ["user.email", "user.username"]
    attributes :client => ["client.name", "client.email", "client.company", "client.city"]
    attributes :items => ["items.name"]
  end

  def colour_state
    return case self.state
    when "paid"
      "green"
    when "open"
      "yellow darken-2"
    when "pending"
      "blue"
    when "quote"
      "blue"
    when "canceled"
      "grey lighten-2"
    else
      "grey"
    end
  end

  def get_state
    {"open" => "Aberto",
     "paid" => "Pago",
     "pending" => "Carteira",
     "quote" => "Orçamento",
     "canceled" => "Cancelado"}[self.state]
  end

  def empty?
    (order_items.count + order_inks.count) <= 0
  end

  def paid?
    return self.state == "paid"
  end

  def money?
    !self.boleto? and !(self.cc_value.to_f >= self.calculate_total)
  end

  def boleto?
    self.boleto
  end

  def pix?
    self.pix
  end

  def open!
    update(state: "open",
           total: calculate_total)
  end

  def open?
    return self.state == "open"
  end

  def pending!
    update(state: "pending")
  end

  def pending?
    return self.state == "pending"
  end

  def stock_id
    self.user.try :stock_id
  end

  def pay! ob=nil
    # if (pending?)
    #   update...
    # end
    
    update(state: "paid", paid_at: DateTime.now)

    if user.try(:stock_id)
      order_items.each do |order_item|
        StockChange.create(item_id: order_item.item_id,
          stock_id: user.try(:stock_id),
          quantity: order_item.quantity,
          state: "out",
          observation: "PDV: Pedido ##{self.id} #{'- Pago com saldo' if ob == 'cash'}").push!
      end
    end
  end

  def pay_with_cash!
    pay! "cash"

    if (client.cash - calculate_total) >= 0
      value = calculate_total
      new_client_cash = (client.cash - calculate_total)
    else
      value = client.cash
      new_client_cash = 0
    end

    update(cashed: value)

    # Output.create(user: self.user,
    #               output_type: 1,
    #               description: "SISTEMA: Pagamento com saldo - Pedido ##{self.id}",
    #               value: value,
    #               stock_id: self.user.stock_id)

    client.update(cash: new_client_cash)
  end

  def quote!
    update(state: "quote")
  end

  def quote?
    return self.state == "quote"
  end

  def cancel!
    update(state: "canceled")
  end

  def clienting params
    c = Client.where(email: params[:email]).first_or_create
    c.update(params)
    self.update(client_id: c.id)
    return c
  end

  def add_item params
    order_item = order_items.select { |oi| oi.item_id == params[:item_id].to_i }.first
    qty = (params[:quantity].to_d > 0) ? params[:quantity].to_d : 1

    unless order_item.blank?
      order_item.quantity += qty
    else
      price = Item.find(params[:item_id]).final_price
      order_item = order_items.new(item_id: params[:item_id], price: price, quantity: qty)
    end

    order_item.save
    return order_item
  end

  def add_tinta params
    if params[:brand] == "wanda"
      return add_wanda params
    elsif params[:brand] == "sw"
      return add_sw params
    end
  end

  def add_wanda params
    ink = Wanda::Ink.find(params[:ink_id])
    order_ink = order_inks.where(
      ink_id: ink.id,
      # recipient_id: ink.sw_recipient.id,
      brand: "wanda",
      recipient_id: params[:recipient]
      # base_id: ink.base.try(:id),
    ).first_or_initialize(
      name: "WANDA #{ink.description.upcase} #{Wanda::Ink.recipient_name(params[:recipient])} #{ink.version}.#{ink.alternative} #{ink.start_year}-#{ink.end_year}",
      price: ink.price(params[:recipient])
    )

    qty = params[:quantity].to_f > 0 ? params[:quantity].to_f : 1

    if (order_ink.quantity.to_f > 0)
      qty += order_ink.quantity.to_f
    end

    order_ink.quantity = qty

    order_ink.save

    return order_ink
  end
    
  def add_sw params
    ink = Ink.find(params[:ink_id])

    order_ink = order_inks.where(
      ink_id: ink.id,
      recipient_id: ink.sw_recipient.id,
      brand: "sw",
      base_id: ink.base.try(:id),
    ).first_or_initialize(
      name: "SW #{ink.sw_product.name} - #{ink.name} #{ink.sw_recipient.name}",
      price: ink.price
    )

    qty = params[:quantity].to_f > 0 ? params[:quantity].to_f : 1

    if (order_ink.quantity.to_f > 0)
      qty += order_ink.quantity.to_f
    end

    order_ink.quantity = qty

    order_ink.save

    return order_ink
  end

  def total
    self.calculate_total
  end

  def calculate_total
    @total_i = order_items.collect  { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
    
    @total_t = order_inks.collect do |oi|
      begin
        oi.valid? ? (oi.total_price) : 0
      rescue => e
        0
      end
    end.sum

    @total = @total_i + @total_t
  end

  def get_discount
    self.discount || 0
  end

  def calculate_qtd
    @total_i = order_items.collect  { |oi| oi.valid? ? (oi.quantity) : 0 }.sum
    @total_t = order_inks.collect { |oi| oi.valid? ? (oi.quantity) : 0 }.sum
    @total = @total_i + @total_t
  end

  def total_discounted
    calculate_total + shipping.to_f - discount.to_f
  end

  def c_total_pix
    total_pix.to_f
  end

  def total_cash
    total_discounted - cc_value.to_f - boleto_value.to_f - cashed.to_f - total_pix.to_f
  end
end
