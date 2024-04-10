require 'rails_helper'

RSpec.feature "PassengersImport", type: :feature do
    let(:csvFile) { Rails.root.join('spec/fixtures/passengers.csv') }
    let(:passenger) { Passenger.create!(name: "Jeff Rustic", email: "jeffrustic@gmail.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001") }

    describe "User imports a CSV file" do
        it "imports successfully with a valid CSV file" do
            initial_passenger_count = Passenger.count
            visit root_path
            attach_file('file', csvFile)
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(passengers_path)
            expect(page).to have_content("Passenger data imported successfully")
            expect(initial_passenger_count).to eq(0)
            expect(new_passenger_count > initial_passenger_count)
        end

        it "fails to import without a CSV file" do
            initial_passenger_count = Passenger.count
            visit root_path
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(import_passengers_path)
            expect(initial_passenger_count).to eq(0)
            expect(new_passenger_count == initial_passenger_count)
        end

        it "does not import duplicates - identified by passenger email" do
            passenger.save! # Persisting to database as needed for this test case
            initial_passenger_count = Passenger.count
            initial_passengers = Passenger.all
            visit root_path
            attach_file('file', csvFile)
            click_button "Import CSV"
            new_passenger_count = Passenger.count

            expect(initial_passenger_count).to eq(1)
            expect(initial_passengers).to include(passenger)
            expect(new_passenger_count > initial_passenger_count)
            expect(Passenger.where(email: "jeffrustic@gmail.com").count).to eq(1)
        end
    end
end