class StockChange < ApplicationRecord
  belongs_to :stock
  belongs_to :item

  belongs_to :stock_transfer, optional: true

  STATES = { "Entrada" => "in", "Saída" => "out" }

  def push!
    stock_item = StockItem.create(item_id: self.item_id, stock_id: self.stock_id)
    if self.state == "in"
      nqt = (stock_item.quantity || 0) + self.quantity
    else
      nqt = (stock_item.quantity || 0) - self.quantity
    end

    stock_item.update(quantity: nqt)
  end
end
