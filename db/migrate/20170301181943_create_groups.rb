class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :family, foreign_key: true
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
