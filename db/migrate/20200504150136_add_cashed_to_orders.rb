class AddCashedToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cashed, :decimal, :precision => 10, :scale => 2
  end
end
