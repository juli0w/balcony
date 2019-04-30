class OrderTinta < ApplicationRecord
  belongs_to :order
  belongs_to :tinta_cor

  def unit_price
    tinta_cor.total_price(tinta_embalagem) || 0
  end

  def tinta_embalagem
    TintaEmbalagem.find(can)
  end

  def total_price
    unit_price * quantity
  end
end
