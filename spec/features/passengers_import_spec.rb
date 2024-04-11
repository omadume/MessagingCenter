require 'rails_helper'

RSpec.feature "PassengersImport", type: :feature do
    let(:csvFile) { Rails.root.join('spec/fixtures/passengers.csv') }
    let(:pdfFile) { Rails.root.join('spec/fixtures/passengers.pdf') }
    let(:passenger) { Passenger.create!(name: "Jeff Rustic", email: "jeffrustic@gmail.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001") }
    let!(:initial_passenger_count) { Passenger.count }

    describe "User imports a CSV file" do
        before do
            visit root_path
        end

        it "imports successfully with a valid CSV file" do
            attach_file('file', csvFile)
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(passengers_path)
            expect(page).to have_content("Passenger data imported successfully")
            expect(initial_passenger_count).to eq(0)
            expect(new_passenger_count > initial_passenger_count)
        end

        it "fails to import with invalid file type" do
            attach_file('file', pdfFile)
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(root_path)
            expect(page).to have_content("Please make sure a CSV file has been selected")
            expect(initial_passenger_count).to eq(0)
            expect(new_passenger_count == initial_passenger_count)
        end

        it "fails to import with no file" do
            click_button "Import CSV"
            new_passenger_count = Passenger.count
            
            expect(page).to have_current_path(root_path)
            expect(page).to have_content("Please make sure a CSV file has been selected")
            expect(initial_passenger_count).to eq(0)
            expect(new_passenger_count == initial_passenger_count)
        end

        it "does not import duplicates - identified by passenger email" do
            passenger.save! # Persisting to database as needed for this test case
            initial_passenger_count = Passenger.count # Updating initial passenger count
            initial_passengers = Passenger.all
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