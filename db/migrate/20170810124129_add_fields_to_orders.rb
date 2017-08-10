class AddFieldsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :district, :string
    add_column :clients, :company, :string
    add_column :orders, :obs, :string
  end
end
