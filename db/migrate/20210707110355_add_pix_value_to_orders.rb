class AddPixValueToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :total_pix, :decimal, scale: 2, precision: 10
  end
end
