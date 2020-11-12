class CreateOrderInks < ActiveRecord::Migration[5.0]
  def change
    create_table :order_inks do |t|
      t.references :order, foreign_key: true
      t.decimal :quantity, :decimal, :precision => 10, :scale => 2
      t.string :name
      t.decimal :price, :decimal, :precision => 10, :scale => 2
      t.string :brand
      t.integer :recipient_id
      t.integer :base_id
      t.integer :product_id
      t.integer :ink_id

      t.timestamps
    end
  end
end
