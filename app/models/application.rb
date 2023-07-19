class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip, :description, presence: true
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def all_pets_approved?
    pet_applications.all? { |pet_application| pet_application.status == "Approved" }
  end

  def all_pets_have_status?
    pet_applications.all? { |pet_application| pet_application.status != "Pending" }
  end

  def adopt_all_pets
    pets.each do |pet|
      pet.update(adoptable: false)
      pet.reload
    end
  end
end