class AddBoletoGeradoToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :boleto_gerado, :boolean, default: false
  end
end
