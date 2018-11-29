class AddCanToOrderTintas < ActiveRecord::Migration[5.0]
  def change
    add_column :order_tinta, :can, :string
  end
end
