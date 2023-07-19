require "rails_helper"

RSpec.describe Application, type: :model do
  describe "relationships" do
    it { should have_many :pet_applications }
    it { should have_many(:pets).through(:pet_applications)}
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe "instance methods" do
    before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    @pet_1 = @shelter_1.pets.create!(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create!(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: "Mugsy", breed: "mixed breed terrier", age: 5, adoptable: true)
    @pet_5 = @shelter_2.pets.create!(name: "Luca", breed: "pitbull", age: 7, adoptable: true)
    @pet_6 = @shelter_3.pets.create!(name: "Enzo", breed: "goldendoodle", age: 1, adoptable: true)
    @application_1 = Application.create!(
      name: "Bob",
      street_address: "123 Fake St",
      city: "Lander",
      state: "WY",
      zip: 82520,
      description: "I am loving and attentive.",
      status: "Accepted")
    @application_2 = Application.create!(
      name: "Sarah",
      street_address: "321 Faux Ln",
      city: "Salt Lake City",
      state: "UT",
      zip: 84104,
      description: "I live in a small apartment but am lonely so want a pet.",
      status: "In Progress")
    @application_3 = Application.create!(
      name: "Jen",
      street_address: "475 Yikes Ave",
      city: "Boulder",
      state: "CO",
      zip: 80301,
      description: "My dog Rex is great with cats",
      status: "Pending")
    @application_4 = Application.create!(
      name: "Dominique",
      street_address: "321 Faux Ln",
      city: "Bloomington",
      state: "IL",
      zip: 61701,
      description: "I love animals.",
      status: "Pending")
    @pet_application_1 = PetApplication.create!(pet: @pet_1, application: @application_1)
    @pet_application_2 = PetApplication.create!(pet: @pet_2, application: @application_1)
    @pet_application_3 = PetApplication.create!(pet: @pet_5, application: @application_3, status: "Approved")
    @pet_application_4 = PetApplication.create!(pet: @pet_6, application: @application_4, status: "Approved")
    @pet_application_5 = PetApplication.create!(pet: @pet_5, application: @application_4, status: "Approved")
    @pet_application_6 = PetApplication.create!(pet: @pet_6, application: @application_3, status: "Rejected")
  end
    it "can check an application to see if all pets have been approved" do
      expect(@application_4.all_pets_approved?).to eq(true)
      expect(@application_1.all_pets_approved?).to eq(false)
    end

    it "can check an application to see if all pets have been assigned a status other than pending" do
      expect(@application_4.all_pets_have_status?).to eq(true)
      expect(@application_3.all_pets_have_status?).to eq(true)
      expect(@application_1.all_pets_have_status?).to eq(false)
    end

    it 'can change all pets in an application from adoptable true to false' do
      expect(@pet_6.adoptable).to eq(true)
      expect(@pet_5.adoptable).to eq(true)
      @application_4.adopt_all_pets
      @pet_6.reload
      @pet_5.reload
      expect(@pet_6.adoptable).to eq(false)
      expect(@pet_5.adoptable).to eq(false)
    end
  end
end