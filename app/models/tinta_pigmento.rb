class TintaPigmento < ApplicationRecord
  belongs_to :fabricante, optional: true
  has_one :tinta_pigmento_item
end
