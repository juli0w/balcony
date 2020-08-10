class CreateStockCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_counts do |t|
      t.references :stock, foreign_key: true
      t.references :item, foreign_key: true
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
