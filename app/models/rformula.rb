class Rformula < ApplicationRecord
  belongs_to :rproduct, optional: true
  belongs_to :rcolor, optional: true
  belongs_to :rline,  optional: true

  include SearchCop

  MARGIN = 50

  search_scope :search do
    attributes :color
    attributes :base
    attributes :rgb
    attributes :line
    attributes :notes
  end

  def calculate_price
    return price unless price.blank?
    
    total_price = 0

    {c1 => q1, c2 => q2, c3 => q3, c4 => q4, c5 => q5, c6 => q6}.each do |c, q|
      puts "#{c} - #{q}"
      total_price += (q * rbase(c).price) unless q.blank?
    end

    update(price: total_price + (total_price * MARGIN/100))

    return price
  end

  def get_base n
    rbase self.send("c#{n}")
  end

  def rbase c=nil
    Rbase.select {|r| r.code.to_i == c.to_i }.first if c
  end
end
