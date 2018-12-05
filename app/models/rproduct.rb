class Rproduct < ApplicationRecord
  belongs_to :item, optional: true
  
  CAN = { "LATA"   => 20,
          "GALAO"  => 4,
          "QUARTO" => 1 }

  def get_price color
    rf = Rformula.where("color LIKE ?", "%#{color}%").first
    if rf
      total_price = 0

      {c1 => q1, c2 => q2, c3 => q3, c4 => q4, c5 => q5, c6 => q6}.each do |c, q|
        puts "#{c} - #{q}"
        total_price += (q * rbase(c).price) unless q.blank?
      end

      return final_price total_price
    end
  end

  def final_price price
    pr = price * CAN[can]
    pr + (pr * MARGIN/100)
  end
end
