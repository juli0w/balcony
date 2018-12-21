class OrderTinta < ApplicationRecord
  belongs_to :order
  belongs_to :rformula

  def unit_price
    rformula.calculate_price(can) || 0
  end

  def total_price
    unit_price * quantity
  end
end
