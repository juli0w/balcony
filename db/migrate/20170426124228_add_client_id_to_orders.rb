class AddClientIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :client_id, :integer
  end
end
