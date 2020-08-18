class CreateStockLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_locations do |t|
      t.references :stock, foreign_key: true
      t.references :item, foreign_key: true
      t.string :location

      t.timestamps
    end
  end
end
