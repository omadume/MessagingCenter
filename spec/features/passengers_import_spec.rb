require 'rails_helper'

RSpec.feature "PassengersImport", type: :feature do

    let(:csvFile) { Rails.root.join('spec/fixtures/passengers.csv') }

    describe "User imports a CSV file" do
        it "imports successfully with a valid CSV file" do
            initial_passenger_count = Passenger.count
            visit root_path
            attach_file('file', csvFile)
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(passengers_path)
            expect(page).to have_content("Passenger data imported successfully")
            expect(page).to have_content("Jeff Rustic")
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
    end
end