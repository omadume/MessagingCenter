class AddPassengerIdToPassenger < ActiveRecord::Migration[7.1]
  def change
    add_column :passengers, :passenger_id, :integer
  end
end
