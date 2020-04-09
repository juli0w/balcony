class AddIndexToItemsCode < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :code, unique: true
    add_index :family, :code, unique: true
    add_index :group, :code, unique: true
    add_index :subgroup, :code, unique: true
  end
end
