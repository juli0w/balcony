class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :client, optional: true

  scope :open, -> { where(state: "open") }
  scope :paid, -> { where(state: "paid") }

  include SearchCop

  search_scope :search do
    attributes :state
    attributes :user => ["user.email"]
    attributes :client => ["client.name", "client.email"]
  end

  def get_state
    {"open" => "Aberto",
     "paid" => "Pago",
     "canceled" => "Cancelado"}[self.state]
  end

  def empty?
    order_items.count <= 0
  end

  def open!
    update(state: "open",
           total: calculate_total)
  end

  def pay!
    update(state: "paid")
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
    qty = (params[:quantity].to_i > 0) ? params[:quantity].to_i : 1

    unless order_item.blank?
      order_item.quantity += qty
    else
      order_item = order_items.new(item_id: params[:item_id], quantity: qty)
    end

    order_item.save
    return order_item
  end

  def calculate_total
    @total = order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end
end
