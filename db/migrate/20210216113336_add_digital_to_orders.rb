class AddDigitalToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :digital, :boolean, default: false
  end
end
