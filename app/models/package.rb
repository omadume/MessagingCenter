class Package < ApplicationRecord
  has_many :passengers
  validates_presence_of :name
end
