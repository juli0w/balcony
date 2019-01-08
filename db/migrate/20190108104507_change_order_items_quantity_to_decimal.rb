class ChangeOrderItemsQuantityToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :order_items, :quantity, :decimal, :precision => 10, :scale => 1
  end
end
