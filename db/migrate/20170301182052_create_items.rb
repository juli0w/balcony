class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :code
      t.string :name
      t.references :group, foreign_key: true
      t.references :family, foreign_key: true
      t.references :subgroup, foreign_key: true
      t.decimal :price, precision: 5, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
