class CreateStockTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_transfers do |t|
      t.integer :from_id
      t.integer :to_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
