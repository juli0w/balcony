class Order < ApplicationRecord
  has_many :order_items,  dependent: :destroy
  has_many :order_tintas, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :client, optional: true

  has_many :items, through: :order_items
  # delegate :items, :to => :order_items, :allow_nil => true

  # default_scope { where("orders.created_at > ?", 1.day.ago) }

  scope :opened, -> { where(state: "open") }
  scope :paid, -> { where(state: "paid") }
  scope :quote, -> { where(state: "quote") }
  scope :canceled, -> { where(state: "canceled") }
  scope :opened_and_quote, -> { where("state = ? or state = ?", "open", "quote") }

  scope :not_empty, -> { where.not(state: "") }

  include SearchCop

  search_scope :search do
    attributes :state
    attributes :seller
    attributes :user => ["user.email", "user.username"]
    attributes :client => ["client.name", "client.email"]
    attributes :items => ["items.name"]
  end

  def get_state
    {"open" => "Aberto",
     "paid" => "Pago",
     "quote" => "Orçamento",
     "canceled" => "Cancelado"}[self.state]
  end

  def empty?
    (order_items.count + order_tintas.count) <= 0
  end

  def open!
    update(state: "open",
           total: calculate_total,
           submited_at: DateTime.now)
  end

  def pay! ob=nil
    update(state: "paid", paid_at: DateTime.now)

    order_items.each do |order_item|
      StockChange.create(item_id: order_item.item_id,
        stock_id: user.try(:stock_id),
        quantity: order_item.quantity,
        state: "out",
        observation: "PDV: Pedido ##{self.id} #{'- Pago com saldo' if ob == 'cash'}").push!
    end
  end

  def pay_with_cash!
    pay! "cash"
    client.update(cash: (client.cash - calculate_total))
  end

  def quote!
    update(state: "quote")
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
      order_item = order_items.new(item_id: params[:item_id], quantity: qty)
    end

    order_item.save
    return order_item
  end

  def add_tinta params
    order_tinta = order_tintas.where(tinta_cor_id: params[:tinta_id].to_i, can: params[:tinta_embalagem_id]).first
    qty = (params[:quantity].to_d > 0) ? params[:quantity].to_d : 1

    unless order_tinta.blank?
      order_tinta.quantity += qty
    else
      order_tinta = order_tintas.new(can: params[:tinta_embalagem_id], tinta_cor_id: params[:tinta_id], quantity: qty)
    end

    order_tinta.save
    return order_tinta
  end

  def calculate_total
    @total_i = order_items.collect  { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
    @total_t = order_tintas.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
    @total = @total_i + @total_t
  end

  def calculate_qtd
    @total_i = order_items.collect  { |oi| oi.valid? ? (oi.quantity) : 0 }.sum
    @total_t = order_tintas.collect { |oi| oi.valid? ? (oi.quantity) : 0 }.sum
    @total = @total_i + @total_t
  end
end
