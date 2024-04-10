require 'rails_helper'

RSpec.describe Passenger, type: :request do
    let!(:passenger) { Passenger.create!(name: "Jenny", email: "jenny@email.com", gender: "x", date_of_birth: "1997-04-10", status: "created", passenger_id: "001") }

    describe "GET /passengers/index" do
        it "returns HTTP success" do
            get passengers_path
            expect(response.status).to eq(200)
        end
    end

    describe "GET /passengers/1" do
        it "returns HTTP success for valid passenger" do
            passenger_id = passenger.id
            get passenger_path(passenger.id)
            expect(response.status).to eq(200)
        end
    end

    describe "GET /passengers/1" do
        it "returns HTTP not found for invalid passenger" do
            get passenger_path(1)
            expect(response.status).to eq(404)
        end
    end

    describe "GET /passengers/new_import" do
        it "returns HTTP success as the root" do
            get root_path
            expect(response.status).to eq(200)
        end
    end
end