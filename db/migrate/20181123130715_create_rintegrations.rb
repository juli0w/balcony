class CreateRintegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :rintegrations do |t|
      t.string :base
      t.string :can
      t.string :line
      t.string :product
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
