class RemovePassengerFromPackage < ActiveRecord::Migration[7.1]
  def change
    remove_reference :packages, :passenger, foreign_key: true
  end
end
