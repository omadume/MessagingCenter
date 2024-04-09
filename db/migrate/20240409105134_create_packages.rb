class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.references :passenger, null: false, foreign_key: true

      t.timestamps
    end
  end
end
