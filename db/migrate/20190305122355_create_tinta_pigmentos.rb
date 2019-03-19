class CreateTintaPigmentos < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_pigmentos do |t|
      t.integer :tinta_pigmento_id
      t.string :codigo
      t.string :descricao
      t.string :integracao_old
      t.integer :fabricante_id

      t.timestamps
    end
  end
end
