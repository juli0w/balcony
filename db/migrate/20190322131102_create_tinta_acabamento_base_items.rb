class CreateTintaAcabamentoBaseItems < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_acabamento_base_items do |t|
      t.references :tinta_acabamento, foreign_key: true
      t.references :tinta_base, foreign_key: true
      t.references :item, foreign_key: true
      t.references :tinta_embalagem, foreign_key: true

      t.timestamps
    end
  end
end
