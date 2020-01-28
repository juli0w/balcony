class AddDefaultStockToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_stock_id, :integer
  end
end
