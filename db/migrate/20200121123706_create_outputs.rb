class CreateOutputs < ActiveRecord::Migration[5.0]
  def change
    create_table :outputs do |t|
      t.references :user, foreign_key: true
      t.decimal :value, :precision => 10, :scale => 2
      t.references :stock, foreign_key: true

      t.timestamps
    end
  end
end
