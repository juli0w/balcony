class AddTintaCorIdToOrderTintas < ActiveRecord::Migration[5.0]
  def change
    add_column :order_tinta, :tinta_cor_id, :integer
  end
end
