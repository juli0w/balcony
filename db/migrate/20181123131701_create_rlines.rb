class CreateRlines < ActiveRecord::Migration[5.0]
  def change
    create_table :rlines do |t|
      t.string :name

      t.timestamps
    end

    add_reference :rformulas, :rline, index: true
  end
end
