class AddStockTransferToStockChange < ActiveRecord::Migration[5.0]
  def change
    add_column :stock_changes, :stock_transfer_id, :integer
  end
end
