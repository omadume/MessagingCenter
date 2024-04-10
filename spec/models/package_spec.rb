require 'rails_helper'

RSpec.describe Package, type: :model do
    let(:package) { Package.new(name: "Package 1")}

    it "is valid with all required attributes" do
        expect(package).to be_valid
    end

    it "is not valid if missing a required attribute" do
        package.name = ""
        expect(package).not_to be_valid
    end

    it "is not valid with an unknown attribute" do
        expect{package.assign_attributes(random_attribute: "random_value")}.to raise_error(ActiveModel::UnknownAttributeError)
    end

    it "is valid with multiple passengers" do
        # Persisting objects to database to allow for checking validity of relational associations
        package.save!
        passenger1 = Passenger.create!(name: "Jenny", email: "jenny@email.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001", package: package)
        passenger2 = Passenger.create!(name: "John", email: "john@email.com", gender: "x", date_of_birth: "1997-04-16", status: "created", passenger_id: "002", package: package)
        expect(package.passengers).to include(passenger1, passenger2)
    end
end