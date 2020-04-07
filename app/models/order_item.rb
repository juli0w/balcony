class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def unit_price
    item.final_price || 0
  end

  def total_price
    unit_price * quantity
  end
end
