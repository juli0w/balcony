class AddFieldsToOutputs < ActiveRecord::Migration[5.0]
  def change
    add_column :outputs, :description, :text
    add_column :outputs, :output_type, :integer
  end
end
