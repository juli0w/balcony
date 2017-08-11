class AddSectionIdToClients < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :section, foreign_key: true
  end
end
