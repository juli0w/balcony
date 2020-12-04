class Wanda::Ink < ApplicationRecord
  include SearchCop
  
  RECIPIENTS = { "200ML" => 0,
                 "QUARTO" => 1,
                 "GALÃO" => 2 }
    
  search_scope :search do
      attributes :description
      attributes :code
  end

  def price recipient=1
    self.read_attribute(:price) * recipient_price(recipient)
  end

  def recipient_price recipient
    { 0 => 0.3, 1 => 1, 2 => 4 }[recipient.to_i] || 0
  end

  def self.recipient_name recipient=1
    RECIPIENTS.key(recipient.to_i)
  end
end
