class CreateRbases < ActiveRecord::Migration[5.0]
  def change
    create_table :rbases do |t|
      t.string :name
      t.string :code
      t.decimal :density, :precision => 8, :scale => 2
      t.integer :rgb

      t.timestamps
    end
  end
end
