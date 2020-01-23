class AddBoletoToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :boleto, :boolean, default: false
  end
end
