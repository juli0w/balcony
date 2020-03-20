class CreateDyes < ActiveRecord::Migration[5.0]
  def change
    create_table :dye_inks do |t|
      t.string :quantity
      t.references :dye, foreign_key: true
      t.references :ink, foreign_key: true
    end

    create_table :dyes do |t|
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2
      t.references :item, foreign_key: true
    end
  end
end
