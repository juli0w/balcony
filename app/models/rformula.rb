class Rformula < ApplicationRecord
  belongs_to :rproduct, optional: true
  belongs_to :rcolor, optional: true
  belongs_to :rline,  optional: true

  include SearchCop

  MARGIN = 50

  CAN = { "LATA"   => 20000,
          "GALAO"  => 3600,
          "QUARTO" => 900 }

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
        value = q * (((rbase(c).price) *1000)/946)/1000
        puts "R$ #{value.to_s}"
        tprice += value
      end
    end

    puts "---------------"
    update(price: tprice)

    return total_price can
  end

  def total_price can=nil
    pr = price * CAN[can]
    total = pr + (pr * MARGIN/100)
    puts "Valor por ml: #{price}"
    puts "Subtotal: #{pr} (#{can} [#{CAN[can]}])"
    puts "Total: #{total}"
    puts "---------------"

    return total
  end

  def get_base n
    rbase self.send("c#{n}")
  end
end
