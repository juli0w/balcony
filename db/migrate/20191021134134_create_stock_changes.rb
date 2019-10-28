class CreateStockChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_changes do |t|
      t.references :stock, foreign_key: true
      t.references :item, foreign_key: true
      t.string :state
      t.string :observation
      t.decimal :quantity, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
