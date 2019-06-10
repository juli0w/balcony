class TintaCor < ApplicationRecord
  include SearchCop

  serialize :formula

  belongs_to :tinta_acabamento, optional: true
  belongs_to :tinta_base, optional: true
  belongs_to :tinta_embalagem, optional: true
  belongs_to :fabricante, optional: true

  search_scope :search do
    attributes :tinta_acabamento => ["tinta_acabamento.descricao"]
    attributes :tinta_base => ["tinta_base.descricao"]
    attributes :tinta_embalagem => ["tinta_embalagem.descricao"]
    attributes :fabricante => ["fabricante.name"]
    attributes :codigo
    attributes :descricao
  end

  MARGIN = 50

  def pigmento n
    TintaPigmento.find_by_id(read_formula[n].keys[0]) if read_formula[n]
  end

  def base tinta_embalagem
    @base ||= TintaAcabamentoBaseItem.where(tinta_acabamento_id: tinta_acabamento.id,
                                            tinta_base_id: tinta_base.id,
                                            tinta_embalagem_id: tinta_embalagem.id).first.try(:item)
  end

  def no_margin_price_pigmentos tinta_embalagem
    total = 0
    (0..5).each do |n|
      unless read_formula[n].blank? or pigmento(n).blank?
        quantidade = read_formula[n].values[0]
        preco = pigmento(n).tinta_pigmento_item.item.price

        total += no_margin_total_pigmento(n, tinta_embalagem)
      end
    end

    return total
  end

  def price_pigmentos tinta_embalagem
    total = 0
    (0..5).each do |n|
      # logger.debug "--------------------"
      # logger.debug formula
      # logger.debug "formula: #{read_formula[n]}"
      # logger.debug "pigmento: #{pigmento(n)}"
      # logger.debug "--------------------"
      unless read_formula[n].blank? or pigmento(n).blank?
        quantidade = read_formula[n].values[0]
        preco = pigmento(n).tinta_pigmento_item.item.price

        total += total_pigmento(n, tinta_embalagem)
      end
    end

    return total
  end

  def total_price tinta_embalagem
    return 0 if base(tinta_embalagem).nil?

    price_pigmentos(tinta_embalagem) + base(tinta_embalagem).try(:price)
  end

  def no_margin_total_pigmento n, tinta_embalagem
    if pigmento(n)
      quantidade = read_formula[n].values[0]
      preco = pigmento(n).tinta_pigmento_item.item.price
      (quantidade.to_d * preco.to_d * tinta_embalagem.quantidade)
    end
  end

  def total_pigmento n, tinta_embalagem
    if pigmento(n)
      quantidade = read_formula[n].values[0]
      preco = pigmento(n).tinta_pigmento_item.item.price
      (quantidade.to_d * preco.to_d * tinta_embalagem.quantidade) *1.5
    end
  end

  def read_formula
    new_formula = []

    formula.gsub("[","").gsub("]","").split(";").each do |pigmento|
      pigmento_id = pigmento.split(":")[0]
      quantidade  = pigmento.split(":")[1]

      tinta_pigmento_id = TintaPigmento.find_by_tinta_pigmento_id(pigmento_id).try(:id)
      new_formula << { tinta_pigmento_id => quantidade }
    end

    new_formula
  end
end
