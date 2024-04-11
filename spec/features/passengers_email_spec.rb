require 'rails_helper'

RSpec.feature "PassengersEmail", type: :feature do
    let!(:passenger1) { Passenger.create!(name: "Jenny", email: "jenny@email.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001") }
    let!(:passenger2) { Passenger.create!(name: "John", email: "john@email.com", gender: "x", date_of_birth: "1997-04-16", status: "cancelled", passenger_id: "002") }

    before do
        visit passengers_path
    end

    describe "User sends emails with no filter selection" do
        it "it sends emails to all passengers" do
            click_button "Send email/message to selection"
            expect(page).to have_content("Messages have been sent to the filtered passengers")

            visit passenger_path(passenger1.id)
            expect(page).to have_content("Hello Jenny")

            visit passenger_path(passenger2.id)
            expect(page).to have_content("Hello John")
        end
    end

    describe "User sends emails with a filter selection" do
        before do
            expect(page).to have_content("Jenny")

            find("#status option[value='cancelled']").select_option
            click_button "Filter"
        end

        it "applies the filter selection correctly" do
            expect(page).not_to have_content("Jenny")
        end

        it "emails the filtered passengers only" do
            click_button "Send email/message to selection"
            expect(page).to have_content("Messages have been sent to the filtered passengers")

            visit passenger_path(passenger2.id)
            expect(page).to have_content("Hello John")

            visit passenger_path(passenger1.id)
            expect(page).not_to have_content("Hello Jenny")
        end
    end
end
