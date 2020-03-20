class DyeInk < ApplicationRecord
    belongs_to :ink
    belongs_to :dye

    def item_price
      dye.item_price
    end
  end
  