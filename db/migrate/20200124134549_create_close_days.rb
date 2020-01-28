class CreateCloseDays < ActiveRecord::Migration[5.0]
  def change
    create_table :close_days do |t|
      t.references :stock, foreign_key: true
      t.date :day
      t.decimal :initial, :precision => 10, :scale => 2
      t.decimal :final, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end
