class CreateWandaInks < ActiveRecord::Migration[5.0]
  def change
    create_table :wanda_inks do |t|
      t.string :description
      t.string :code
      t.decimal :price
      t.string :recipient
      t.string :base
      t.string :product

      t.timestamps
    end
  end
end
