class AddTintaEmbalagemIdToTintaCors < ActiveRecord::Migration[5.0]
  def change
    add_column :tinta_cors, :tinta_embalagem_id, :integer
  end
end
