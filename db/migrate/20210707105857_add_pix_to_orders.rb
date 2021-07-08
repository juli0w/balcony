class AddPixToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :pix, :boolean, default: false
  end
end
