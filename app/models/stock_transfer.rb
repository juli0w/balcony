class StockTransfer < ApplicationRecord
  belongs_to :user
  has_many :stock_changes

  def push! cart
    cart.order_items.each do |oi|
      [:from_id, :to_id].each do |operation|
        StockChange.create(
          quantity: oi.quantity,
          item_id: oi.item_id,
          stock_id: self.send(operation),
          state: (operation == :from_id ? "out" : "in"),
          observation: "[Transferência] #{(operation == :from_id ? 'Recebido de' : 'Enviado para')} #{self.stock(operation).name}"
        ).push!
      end
    end
  end

  def stock operation
    Stock.find(self.send(operation))
  end
end
