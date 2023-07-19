class PetApplication < ApplicationRecord
  validates :status, presence: true
  belongs_to :pet
  belongs_to :application
end