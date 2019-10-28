class Stock < ApplicationRecord
  belongs_to :user
  has_many :stock_items

  def of_item item_id
    StockItem.where(stock_id: self.id, item_id: item_id).first_or_create.quantity.to_f
  end
end
