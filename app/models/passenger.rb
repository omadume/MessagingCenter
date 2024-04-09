require 'csv'

class Passenger < ApplicationRecord
    belongs_to :package, optional: true
    validates_presence_of :name, :email, :gender, :date_of_birth, :status # Assumption that all of this data was mandatory for a user account to have even been 'created' and  exist in the spreadsheet
    
    def self.importCsv(file)
        begin
            CSV.foreach(file.path, headers: true){ |row|
                passenger_attributes = row.to_hash # Convert CSV row data to hash using column headers

                # Remove Package column data and use to create Package object
                package_name = passenger_attributes.delete("Package")
                package = Package.find_or_create_by(name: package_name) if package_name.present?

                # Create or update Passenger object, with a Package
                passenger = Passenger.find_or_initialize_by(email: passenger_attributes["Email"])
                passenger.assign_attributes(passenger_attributes)
                passenger.package = package if package.present?
                passenger.save!
            }
        rescue ActiveRecord::RecordInvalid => e
            puts "Failed to import CSV: #{ e.message }" # Make this a UI message later
        end
    end
end
