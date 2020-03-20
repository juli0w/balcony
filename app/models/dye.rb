class Dye < ApplicationRecord
    belongs_to :item, optional: true

    def item_price
        item.try :price
    end
end
