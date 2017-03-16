class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :phone
      t.string :uf
      t.string :cep
      t.string :cpf
      t.date :birthday
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
