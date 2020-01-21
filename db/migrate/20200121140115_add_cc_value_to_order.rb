class AddCcValueToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cc_value, :decimal, :precision => 10, :scale => 1, default: 0
  end
end
