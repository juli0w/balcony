class AddLineAndBirthdayToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :line, :string
    # add_column :clients, :birthday, :date
  end
end
