class AddPriceToRbases < ActiveRecord::Migration[5.0]
  def change
    add_column :rbases, :price, :decimal, precision: 10, scale: 2
  end
end
