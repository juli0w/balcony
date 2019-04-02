class CreateTintaPigmentoItems < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_pigmento_items do |t|
      t.integer :tinta_pigmento_id
      t.integer :tinta_pigmento_item_id
      t.integer :item_id
      t.integer :codigo_numerico

      t.timestamps
    end
  end
end
