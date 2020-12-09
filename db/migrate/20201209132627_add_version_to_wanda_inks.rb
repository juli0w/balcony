class AddVersionToWandaInks < ActiveRecord::Migration[5.0]
  def change
    add_column :wanda_inks, :version, :integer
    add_column :wanda_inks, :alternative, :integer
    add_column :wanda_inks, :start_year, :integer
    add_column :wanda_inks, :end_year, :integer
    add_column :wanda_inks, :date, :string

    add_index :wanda_inks, :version
    add_index :wanda_inks, :alternative
    add_index :wanda_inks, :start_year
    add_index :wanda_inks, :end_year
  end
end
