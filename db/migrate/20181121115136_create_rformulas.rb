class CreateRformulas < ActiveRecord::Migration[5.0]
  def change
    create_table :rformulas do |t|
      t.references :rproduct, foreign_key: true
      t.string :color
      t.string :base
      t.string :line
      t.string :rgb
      t.integer :c1
      t.decimal :q1, :precision => 8, :scale => 2
      t.integer :c2
      t.decimal :q2, :precision => 8, :scale => 2
      t.integer :c3
      t.decimal :q3, :precision => 8, :scale => 2
      t.integer :c4
      t.decimal :q4, :precision => 8, :scale => 2
      t.integer :c5
      t.decimal :q5, :precision => 8, :scale => 2
      t.integer :c6
      t.decimal :q6, :precision => 8, :scale => 2
      t.string :notes
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
