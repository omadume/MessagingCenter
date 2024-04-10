require 'rails_helper'

RSpec.describe Passenger, type: :model do
    let(:passenger) { Passenger.new(name: "Jenny", email: "jenny@email.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001") }
    let(:package) { Package.new(name: "Package 1")}

    it "is valid with all required attributes" do
        expect(passenger).to be_valid
    end

    it "is not valid if missing a required attribute" do
        passenger.name = ""
        expect(passenger).not_to be_valid
    end

    it "is not valid with an unknown attribute" do
        expect{ passenger.assign_attributes(random_attribute: "random_value") }.to raise_error(ActiveModel::UnknownAttributeError)
    end

    it "is valid with one package (not required)" do
        passenger.package = package
        expect(passenger).to be_valid
    end

    it "is not valid with multiple packages" do
        expect{ passenger.package = [] }.to raise_error(ActiveRecord::AssociationTypeMismatch)
    end

    it "is valid with array of messages (not required)" do
        passenger.messages = []
        expect(passenger).to be_valid
    end

end