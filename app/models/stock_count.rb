class StockCount < ApplicationRecord
  belongs_to :stock
  belongs_to :item
end
