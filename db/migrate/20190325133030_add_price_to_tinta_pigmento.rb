class AddPriceToTintaPigmento < ActiveRecord::Migration[5.0]
  def change
    add_column :tinta_pigmentos, :price, :decimal, precision: 10, scale: 2
  end
end
