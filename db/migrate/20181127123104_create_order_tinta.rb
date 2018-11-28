class CreateOrderTinta < ActiveRecord::Migration[5.0]
  def change
    create_table :order_tinta do |t|
      t.references :order, foreign_key: true, index: true
      t.references :rformula, foreign_key: true, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
