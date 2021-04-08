class AddBarcodeToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :barcode, :string
  end
end
