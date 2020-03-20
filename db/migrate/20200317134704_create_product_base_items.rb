class CreateProductBaseItems < ActiveRecord::Migration[5.0]
  def change
    create_table :product_base_items do |t|
      t.references :sw_product, foreign_key: true
      t.references :sw_base, foreign_key: true
      t.references :sw_recipient, foreign_key: true
      t.references :item, foreign_key: true
    end
  end
end
