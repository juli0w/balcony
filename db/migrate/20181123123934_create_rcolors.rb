class CreateRcolors < ActiveRecord::Migration[5.0]
  def change
    create_table :rcolors do |t|
      t.string :name

      t.timestamps
    end

    add_reference :rformulas, :rcolor, index: true
  end
end
