class CreateTintaProdutos < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_produtos do |t|
      t.integer :tinta_produto_id
      t.string :descricao
      t.integer :integracao_id
      t.integer :fabricante_id

      t.timestamps
    end
  end
end
