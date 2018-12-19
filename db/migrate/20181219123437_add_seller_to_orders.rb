class AddSellerToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :seller, :string
  end
end
