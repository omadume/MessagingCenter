class AddMessagesToPassenger < ActiveRecord::Migration[7.1]
  def change
    add_column :passengers, :messages, :text, array: true, default: []
  end
end
