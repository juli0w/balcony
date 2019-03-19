class CreateTintaBases < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_bases do |t|
      t.integer :tinta_base_id
      t.string :descricao
      t.string :integracao_old
      t.integer :fabricante_id
      t.decimal :preco, precision: 10, scale: 2
      t.integer :item_id

      t.timestamps
    end
  end
end
