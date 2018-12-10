class Rformula < ApplicationRecord
  belongs_to :rproduct, optional: true
  belongs_to :rcolor, optional: true
  belongs_to :rline,  optional: true

  include SearchCop

  MARGIN = 50

  CAN = { "LATA"   => 20,
          "GALAO"  => 4,
          "QUARTO" => 1 }

  search_scope :search do
    attributes :color
    attributes :base
    attributes :rgb
    attributes :line
    attributes :notes
  end

  def rbase c=nil
    Rbase.select {|r| r.code.to_i == c.to_i }.first if c
  end

  def calculate_price can=nil
    tprice = 0

    puts "---------------"
    puts "Calculando pigmentos"
    {c1 => q1, c2 => q2, c3 => q3, c4 => q4, c5 => q5, c6 => q6}.each do |c, q|
      unless q.blank?
        puts "---------------"
        puts "Pigmento: #{rbase(c).code} [R$ #{rbase(c).price}] -> #{q}mL"
        value = q * ((rbase(c).price) /946)
        puts "R$ #{value.to_s}"
        tprice += value
      end
    end

    puts "---------------"
    # update(price: tprice)

    return total_price(can, tprice)
  end

  def total_price can=nil, tprice=nil
    pr = tprice * CAN[can]
    rprod = Rproduct.where(can: can, base: base, code: rproduct.code).first
    rpr   = rprod.item.try(:price) || 0
    puts "Integrado com #{rprod.item.try(:name) || '[missing]'}"
    unless rprod.item.nil?
      total = pr + (pr * MARGIN/100) + rpr
    else
      total = 0
    end

    puts "Valor por ml: #{tprice}"
    puts "Subtotal: #{pr} (#{can} [#{CAN[can]}])"
    puts "Total: #{total}"
    puts "---------------"

    return total
  end

  def get_base n
    rbase self.send("c#{n}")
  end
end
