json.extract! passenger, :id, :name, :email, :gender, :date_of_birth, :status, :created_at, :updated_at
json.url passenger_url(passenger, format: :json)
