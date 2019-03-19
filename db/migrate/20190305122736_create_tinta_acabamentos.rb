class CreateTintaAcabamentos < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_acabamentos do |t|
      t.integer :tinta_acabamento_id
      t.string :descricao
      t.references :tinta_produto, foreign_key: true
      t.string :itnegracao_old

      t.timestamps
    end
  end
end
