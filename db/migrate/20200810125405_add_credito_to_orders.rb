class AddCreditoToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :credito, :boolean, default: false
  end
end
