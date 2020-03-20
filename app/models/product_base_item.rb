class ProductBaseItem < ApplicationRecord
  belongs_to :sw_product
  belongs_to :sw_base
  belongs_to :sw_recipient
  belongs_to :item, optional: true

  def self.populate!
    SwBase.all.each do |base|
      SwProduct.all.each do |product|
        SwRecipient.all.each do |recipient|
          self.where(sw_base: base,
                     sw_product: product,
                     sw_recipient: recipient).first_or_create
        end
      end
    end
  end
end
