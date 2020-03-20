class CreateInks < ActiveRecord::Migration[5.0]
  def change
    create_table :sw_products do |t|
      t.string :name
    end

    create_table :sw_bases do |t|
      t.string :name
      t.references :item, foreign_key: true
    end

    create_table :sw_recipients do |t|
      t.string :name
      t.string :capacity
    end

    create_table :inks do |t|
      t.string :collection
      t.string :code
      t.string :name
      t.string :message
      t.references :sw_product, foreign_key: true
      t.references :sw_base, foreign_key: true
      t.references :sw_recipient, foreign_key: true
    end

    add_index :inks, :collection
    add_index :inks, :code
    add_index :inks, :name
  end
end
