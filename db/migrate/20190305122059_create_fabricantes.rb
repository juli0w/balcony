class CreateFabricantes < ActiveRecord::Migration[5.0]
  def change
    create_table :fabricantes do |t|
      t.integer :fabricante_id
      t.string :name

      t.timestamps
    end
  end
end
