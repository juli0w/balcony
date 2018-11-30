class Rformula < ApplicationRecord
  belongs_to :rproduct, optional: true
  belongs_to :rcolor, optional: true
  belongs_to :rline,  optional: true

  include SearchCop

  MARGIN = 40

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

    {c1 => q1, c2 => q2, c3 => q3, c4 => q4, c5 => q5, c6 => q6}.each do |c, q|
      puts "#{c} - #{q}"
      tprice += q * (((rbase(c).price) *1000)/946)/1000 unless q.blank?
    end

    update(price: tprice)

    return total_price can
  end

  def total_price can=nil
    pr = price * CAN[can]
    pr + (pr * MARGIN/100)
  end

  def get_base n
    rbase self.send("c#{n}")
  end
end
