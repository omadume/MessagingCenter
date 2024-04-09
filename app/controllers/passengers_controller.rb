class PassengersController < ApplicationController
  before_action :set_passenger, only: %i[ show ]

  # GET /passengers or /passengers.json
  def index
    # Set up dropdown filter options
    @package_names = Package.select(:name).order(:name).distinct.pluck(:name)
    @statuses = Passenger.select(:status).distinct.pluck(:status)

    @passengers = Passenger.all

    # Apply filtering if needed
    @passengers = @passengers.joins(:package).where(package: { name: params[:package_name] }) if params[:package_name].present?
    @passengers = @passengers.where(status: params[:status]) if params[:status].present?
    if params[:age_group].present?
      @passengers = @passengers.select do |passenger|
        params[:age_group] == 'adult' ? passenger.age >= 18 : passenger.age < 18
      end
    end
  end

  # GET /passengers/new_import
  def new_import
  end

  # Handle the import of a CSV containing Passenger data
  def import
    flash[:notice] = Passenger.importCsv(params[:file])
    redirect_to passengers_url
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
