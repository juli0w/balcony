class CreateTintaCors < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_cors do |t|
      t.integer :tinta_cor_id
      t.string :codigo
      t.string :descricao
      t.references :tinta_acabamento, foreign_key: true
      t.references :tinta_base, foreign_key: true
      t.string :observacao
      t.integer :quantidade
      t.text :formula
      t.references :fabricante, foreign_key: true
      t.string :integracao_old
      t.decimal :quantidade_old, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end
