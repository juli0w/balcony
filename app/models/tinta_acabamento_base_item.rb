class TintaAcabamentoBaseItem < ApplicationRecord
  belongs_to :tinta_acabamento, optional: true
  belongs_to :tinta_base, optional: true
  belongs_to :item, optional: true
  belongs_to :tinta_embalagem, optional: true
end
