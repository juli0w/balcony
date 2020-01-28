class AddDiscountAndShippingToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :discount, :decimal, default: 0, :precision => 10, :scale => 2
    add_column :orders, :shipping, :decimal, default: 0, :precision => 10, :scale => 2
  end
end
