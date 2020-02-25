class AddBoletoValueToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :boleto_value, :decimal, :precision => 10, :scale => 1, default: 0
  end
end
