class CreateTintaEmbalagems < ActiveRecord::Migration[5.0]
  def change
    create_table :tinta_embalagems do |t|
      t.integer :tinta_embalagem_id
      t.string :descricao
      t.decimal :quantidade, :precision => 10, :scale => 2
      t.decimal :quantidade_old, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end
