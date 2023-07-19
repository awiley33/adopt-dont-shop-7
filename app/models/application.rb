class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip, :description, :status, presence: true
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def all_pets_approved?
    pet_applications.where.not(status: "Approved").empty?
  end

  def all_pets_have_status?
    pet_applications.where.not(status: "Pending").exists?
  end

  def adopt_all_pets
    pets.update_all(adoptable: false)
    pets.reload
  end
end