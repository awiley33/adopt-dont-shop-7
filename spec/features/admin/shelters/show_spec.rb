require 'rails_helper'

RSpec.describe "/admin/shelters show page" do
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
    @pet_application_3 = PetApplication.create!(pet: @pet_5, application: @application_3)
    @pet_application_4 = PetApplication.create!(pet: @pet_6, application: @application_4)
  end

  it "displays the shelter's name and full address" do
    visit "/admin/shelters/#{@shelter_1.id}"

    expect(page).to have_content("Aurora shelter")
    expect(page).to have_content("Aurora, CO")
    expect(page).to_not have_content("RGV animal shelter")
    expect(page).to_not have_content("Harlingen, TX")
    
    visit "/admin/shelters/#{@shelter_3.id}"
    
    expect(page).to have_content("Fancy pets of Colorado")
    expect(page).to have_content("Denver, CO")
    expect(page).to_not have_content("RGV animal shelter")
    expect(page).to_not have_content("Harlingen, TX")
  end

  describe "statistics section" do
    it "displays average age of all adoptable pets" do
      visit "/admin/shelters/#{@shelter_1.id}"
      expect(page).to have_content("4.0")
      
      visit "/admin/shelters/#{@shelter_3.id}"
      
      expect(page).to have_content("4.5")
      save_and_open_page
save_and_open_page
    end
  end
end