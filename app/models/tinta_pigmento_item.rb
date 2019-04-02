class TintaPigmentoItem < ApplicationRecord
  belongs_to :item, optional: true
  belongs_to :tinta_pigmento, optional: true
end
