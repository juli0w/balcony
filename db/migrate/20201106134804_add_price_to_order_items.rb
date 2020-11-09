class AddPriceToOrderItems < ActiveRecord::Migration[5.0]
  def change
    # add_column :order_items, :price, :decimal, :precision => 10, :scale => 2

    OrderItem.all.each do |oi|
      oi.update(price: oi.item.try(:price))
    end
  end
end
