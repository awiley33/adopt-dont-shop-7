require "rails_helper"

RSpec.describe "the /admin/application show" do
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
    @pet_application_5 = PetApplication.create!(pet: @pet_5, application: @application_4)
  end

  xit "has a button which approves the application for that specific pet and makes the pet no longer be adoptable" do
    visit "/admin/applications/#{@application_4.id}"
    
    expect(@pet_application_4.status).to eq("Pending")
    expect(@pet_6.adoptable).to eq(true)

    click_button("Approve Adoption of #{@pet_6.name}")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")
    @pet_application_4.reload
    @pet_6.reload
    expect(@pet_application_4.status).to eq("Approved")
    expect(@pet_6.adoptable).to eq(false)

    expect(@pet_application_5.status).to eq("Pending")
    expect(@pet_5.adoptable).to eq(true)
    click_button("Approve Adoption of Luca")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")

    @pet_application_5.reload
    @pet_5.reload
    expect(@pet_application_5.status).to eq("Approved")
    expect(@pet_5.adoptable).to eq(false)
  end

  it "displays a status indicator instead of the button once approved" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Enzo" do 

      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Approved")


      click_button("Approve Adoption of Enzo")


      expect(current_path).to eq("/admin/applications/#{@application_4.id}")


      expect(page).to have_content("Approved")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Approve Adoption of Enzo")
      end

    within "#Luca" do 
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Approved")
      click_button("Approve Adoption of Luca")
      expect(current_path).to eq("/admin/applications/#{@application_4.id}")
      expect(page).to have_content("Approved")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Approve Adoption of Luca")
      end
    end
  end
