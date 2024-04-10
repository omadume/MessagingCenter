class PassengersController < ApplicationController
  before_action :set_passenger, only: %i[ show ]
  before_action :set_filter_options, only: [:index, :email]

  # GET /passengers
  def index
    @passengers = filter_passengers
  end

  # GET /passengers/new_import
  def new_import
  end

  # POST (collection) /passengers/import
  # Handle the import of a CSV containing Passenger data
  def import
    return unless params[:file].present?

    if Passenger.importCsv(params[:file])
      flash[:notice] = "Passenger data imported successfully"
    else
      flash[:alert] = "Failed to import CSV"
    end

    redirect_to passengers_path
  end

  # POST (collection) /passengers/email
  # Handle the emailing/messaging of a select group of passengers
  def email
    begin
      @passengers = filter_passengers

      if @passengers.present?
        @passengers.each{ |passenger|
          # PassengerMailer.with(passenger: passenger).email.deliver_later - Commented out as we are not required to send actual emails for this task

          # Rendering plain text email content to a string to be stored in passenger.messages array
            message_content = render_to_string(
            template: "passenger_mailer/passenger_email",
            layout: false,
            formats: [:text],
            locals: { passenger: passenger }
          )
          
          passenger.messages << message_content
          passenger.save!
        }
        flash[:notice] = "Messages have been sent to the filtered passengers"
        redirect_to passengers_path
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Failed to save passenger messages: #{ e.message }"
      flash[:alert] = "Failed to save passenger messages"
    end
  end

  # GET /passengers/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_passenger
      @passenger = Passenger.find(params[:id])
    end

    # Setup filter dropdown options ahead of certain action calls
    def set_filter_options
      @package_names = Package.select(:name).order(:name).distinct.pluck(:name)
      @statuses = Passenger.select(:status).distinct.pluck(:status)
    end

    # Handle passenger filter selection
    def filter_passengers
      passengers_selection = Passenger.all
  
      if params[:package_name].present?
        passengers_selection = passengers_selection.joins(:package).where(packages: { name: params[:package_name] })
      end 

      if params[:status].present?
        passengers_selection = passengers_selection.where(status: params[:status])
      end

      if params[:age_group].present?
        passengers_selection = passengers_selection.select{ |passenger|
          params[:age_group] == 'adult' ? passenger.age >= 18 : passenger.age < 18
        }
      end
  
      return passengers_selection
    end
end
