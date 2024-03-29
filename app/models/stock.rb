class Stock < ApplicationRecord
  belongs_to :user
  has_many :stock_items
  has_many :stock_locations

  def of_item item_id
    StockItem.where(stock_id: self.id, item_id: item_id).sum{|s| (s.quantity || 0) }
  end

  def location_of item_id
    StockLocation.where(stock_id: self.id, item_id: item_id).first.try(:location)
  end

  def checked? item_id
    StockCount.where(stock_id: self.id, item_id: item_id).first_or_create.checked
  end
end
