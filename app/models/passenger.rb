class Passenger < ApplicationRecord
    belongs_to :package, optional: true
end
