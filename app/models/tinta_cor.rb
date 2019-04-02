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

  def read_formula
    new_formula = []

    formula.gsub("[","").gsub("]","").split(";").each do |pigmento|
      pigmento_id = pigmento.split(":")[0]
      quantidade  = pigmento.split(":")[1]

      tinta_pigmento_id = TintaPigmento.find_by_tinta_pigmento_id(pigmento_id).id
      new_formula << { tinta_pigmento_id => quantidade }
    end

    new_formula
  end

  def calculate_price tinta_embalagem_id
    tprice = 0

    puts "---------------"
    puts "Calculando pigmentos"
    read_formula.each do |f|
      puts "---------------"
      c = f.keys[0]
      q = f.values[0]
      tinta_pigmento = TintaPigmento.find(c)

      unless q.blank? || tinta_pigmento.price.blank?
        puts "Pigmento: #{tinta_pigmento.codigo} [R$ #{tinta_pigmento.price}] -> #{q}mL"
        value = q.to_d * ((tinta_pigmento.price) /946)
        puts "R$ #{value.to_s}"
        tprice += value
      end
    end

    puts "---------------"

    return total_price(tinta_embalagem_id, tprice) || 0
  end

  def total_price tinta_embalagem_id=nil, tprice=nil
    tinta_embalagem = TintaEmbalagem.find(tinta_embalagem_id)
    pr = tprice * tinta_embalagem.quantidade

    total = pr + (pr * MARGIN/100)

    puts "Valor por ml: #{tprice}"
    puts "Subtotal: #{pr} (#{tinta_embalagem.descricao} [#{tinta_embalagem.quantidade}])"
    puts "Total: #{total}"
    puts "---------------"

    return total || 0
  end
end
