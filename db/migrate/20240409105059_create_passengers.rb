class CreatePassengers < ActiveRecord::Migration[7.1]
  def change
    create_table :passengers do |t|
      t.string :name
      t.string :email
      t.string :gender
      t.date :date_of_birth
      t.string :status

      t.timestamps
    end
  end
end
