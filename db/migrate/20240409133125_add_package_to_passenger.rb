class AddPackageToPassenger < ActiveRecord::Migration[7.1]
  def change
    add_reference :passengers, :package, null: true, foreign_key: true
  end
end
