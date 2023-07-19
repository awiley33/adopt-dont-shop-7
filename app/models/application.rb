class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip, :description, presence: true
  has_many :pet_applications
  has_many :pets, through: :pet_applications
end