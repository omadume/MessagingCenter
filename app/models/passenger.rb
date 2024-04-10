require 'csv'

class Passenger < ApplicationRecord
    belongs_to :package, optional: true
    validates_presence_of :name, :email, :gender, :date_of_birth, :status, :passenger_id # Assumption that a Passenger may not have a Package upon account creation
    
    def self.importCsv(file)
        begin
            CSV.foreach(file.path, headers: true){ |row|
                # Convert CSV row data to hash using column headers, and transform to match model naming conventions
                passenger_attributes = row.to_hash.transform_keys{ |key| key.downcase.gsub(' ', '_') }

                # Remove Package column data and use to create Package object
                package_name = passenger_attributes.delete("package")
                package = Package.find_or_create_by!(name: package_name) if package_name.present?

                # Extract and map certain csv column data separately to avoid name mismatch with model
                full_name = passenger_attributes.delete("full_name")
                passenger_attributes["name"] = full_name if full_name.present?

                # Create or update Passenger object, with a Package
                passenger = Passenger.find_or_initialize_by(email: passenger_attributes["email"])
                passenger.assign_attributes(passenger_attributes)
                passenger.package = package if package.present?
                passenger.save!
            }
            return true

        rescue ActiveRecord::RecordInvalid => e
            logger.error "Failed to import CSV: #{ e.message }"
            return false
        end
    end

    def age
        Date.today.year - date_of_birth.year
    end
end
