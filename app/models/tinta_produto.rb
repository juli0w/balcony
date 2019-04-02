class TintaProduto < ApplicationRecord
  has_one :tinta_acabamento
  belongs_to :fabricante
end
