class PassengersController < ApplicationController
  before_action :set_passenger, only: %i[ show ]

  # GET /passengers or /passengers.json
  def index
    @passengers = Passenger.all
  end

  # GET /passengers/new_import
  def new_import
  end

  # Handle the import of a CSV containing Passenger data
  def import
    Passenger.importCsv(params[:file])
    redirect_to passengers_url, notice: "Passenger data imported successfully"
  end

  # GET /passengers/new_email
  def new_email
  end

  # Handle the emailing of a select group of passengers
  def email
  end

  # GET /passengers/1 or /passengers/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_passenger
      @passenger = Passenger.find(params[:id])
    end
end
