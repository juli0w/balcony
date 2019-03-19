class TintaCor < ApplicationRecord
  serialize :formula
  
  belongs_to :tinta_acabamento
  belongs_to :tinta_base
  belongs_to :fabricante
end
