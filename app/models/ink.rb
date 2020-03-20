class Ink < ApplicationRecord
    has_many :dye_inks
    has_many :dyes, through: :dye_inks

    belongs_to :sw_product
    belongs_to :sw_base
    belongs_to :sw_recipient

    include SearchCop
    
    search_scope :search do
        attributes :name
        attributes :code
    end

    def price_dyes
        dye_inks.map {|di| di.item_price.to_d * di.quantity.to_d }.sum 
    end

    def product
        self.sw_product
    end

    def base
        ProductBaseItem.where(sw_product: self.sw_product,
                              sw_base: self.sw_base,
                              sw_recipient: self.sw_recipient).first.try :item
    end

    def recipient
        self.sw_recipient
    end

    def price_with_no_margin
        price_dyes + self.base_price
    end

    def price
        price_dyes*1.5 + self.base_price
    end

    def base_price
        return self.base.try(:price) || 0
    end
end
