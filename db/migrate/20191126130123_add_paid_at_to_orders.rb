class AddPaidAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :paid_at, :datetime
    add_column :orders, :submited_at, :datetime
  end
end
