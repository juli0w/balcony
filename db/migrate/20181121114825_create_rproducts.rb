class CreateRproducts < ActiveRecord::Migration[5.0]
  def change
    create_table :rproducts do |t|
      t.string :name
      t.string :code
      t.string :base
      t.decimal :density, :precision => 8, :scale => 2
      t.string :can
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
