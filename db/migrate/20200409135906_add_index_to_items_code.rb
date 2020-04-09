class AddIndexToItemsCode < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :code, unique: true
    add_index :families, :code, unique: true
    add_index :groups, :code, unique: true
    add_index :subgroups, :code, unique: true
  end
end
