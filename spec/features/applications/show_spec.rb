require "rails_helper"

RSpec.describe "applications" do
  before :each do
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

    @shelter_1 = Shelter.create!(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    
    @pet_1 = @shelter_1.pets.create!(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create!(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: "Ann", breed: "ragdoll", age: 5, adoptable: true)

    @pet_application_1 = PetApplication.create!(pet: @pet_1, application: @application_1)
    @pet_application_2 = PetApplication.create!(pet: @pet_2, application: @application_1)
  end

  describe "show page" do
    it "displays an applicant's name and other attributes" do
      visit "/applications/#{@application_1.id}"
      expect(page).to have_content(@application_1.name)
      expect(page).to have_content(@application_1.street_address)
      expect(page).to have_content(@application_1.city)
      expect(page).to have_content(@application_1.state)
      expect(page).to have_content(@application_1.zip)
      expect(page).to have_content(@application_1.description)
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_content(@pet_2.name)
      expect(page).to have_content(@application_1.status)
    end

    it "has a link to each pets show page if you click their name" do
      visit "/applications/#{@application_1.id}"

      click_on(@pet_1.name)
      expect(current_path).to eq("/pets/#{@pet_1.id}")
      visit "/applications/#{@application_1.id}"
      
      click_on(@pet_2.name)
      expect(current_path).to eq("/pets/#{@pet_2.id}")
    end

    it "has a means to search for pets to add to an application if unsubmitted" do
      visit "/applications/#{@application_2.id}"
      expect(page).to_not have_content("Ann")

      fill_in(:pet_name, with: 'Ann')
      click_button('Search Pets')

      expect(current_path).to eq("/applications/#{@application_2.id}")
      expect(page).to have_content("Ann")
      
      visit "/applications/#{@application_1.id}"
      expect(page).to_not have_content("Search Pets")
    end

    it "has a button next to each search result which adds pet to application" do
      visit "/applications/#{@application_2.id}"
      expect(page).to_not have_content("Ann")

      fill_in(:pet_name, with: 'Ann')
      click_button('Search Pets')

      expect(current_path).to eq("/applications/#{@application_2.id}")
      expect("Ann").to_not appear_before("Add a Pet to this Application")
      click_button("Adopt this Pet")
      
      expect(current_path).to eq("/applications/#{@application_2.id}")
      expect(@application_2.pets[0].name).to eq("Ann")
      expect("Ann").to appear_before("Add a Pet to this Application")
    end

    it "has a field to provide reason for wanting pet(s) and button to submit the application" do
      visit "/applications/#{@application_2.id}"
      expect(page).to_not have_content("Application Submission")

      fill_in(:pet_name, with: 'Ann')
      click_button('Search Pets')
      click_button("Adopt this Pet")

      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_content("Search for pets by name:")
      expect(page).to have_content("Application Submission")
      
      fill_in(:reason, with: 'I think Ann is just the cutest!')
      click_button('Submit Application')
      expect(current_path).to eq("/applications/#{@application_2.id}")

      expect(page).to_not have_content("Application Submission")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Search for pets by name:")
      expect(page).to have_content("Pending")
      expect(page).to have_content("Ann")
    end

    it "can submit an application for multiple pets" do
      visit "/applications/#{@application_2.id}"
      expect(page).to_not have_content("Application Submission")
      expect(page).to_not have_content("Ann")
      expect(page).to_not have_content("Clawdia")

      fill_in(:pet_name, with: 'Ann')
      click_button('Search Pets')
      click_button("Adopt this Pet")

      fill_in(:pet_name, with: 'Clawdia')
      click_button('Search Pets')
      click_button("Adopt this Pet")

      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_content("Search for pets by name:")
      expect(page).to have_content("Application Submission")
      
      fill_in(:reason, with: 'I think Ann and Clawdia would live happily together in my home!')
      click_button('Submit Application')
      expect(current_path).to eq("/applications/#{@application_2.id}")

      expect(page).to_not have_content("Application Submission")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Search for pets by name:")
      expect(page).to have_content("Pending")
      expect(page).to have_content("Ann")
      expect(page).to have_content("Clawdia")
    end
    
    it "can not be submitted if no pets have been added to application" do
      visit "/applications/#{@application_2.id}"
      
      expect(@application_2.pets).to eq([])
      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Application Submission")
    end
    
    it "will display results that partially match pet search terms" do
      visit "/applications/#{@application_2.id}"
      
      fill_in(:pet_name, with: 'An')
      click_button('Search Pets')
      
      expect(page).to have_content("Ann")
      
      fill_in(:pet_name, with: 'Claw')
      click_button('Search Pets')
      
      expect(page).to have_content("Clawdia")
    end
    
    it "has a case insensitive pet search" do
    visit "/applications/#{@application_2.id}"

      fill_in(:pet_name, with: 'ANN')
      click_button('Search Pets')

      expect(page).to have_content("Ann")
      
      fill_in(:pet_name, with: 'cLaWDIa')
      click_button('Search Pets')

      expect(page).to have_content("Clawdia")
      
      fill_in(:pet_name, with: 'pirate')
      click_button('Search Pets')

      expect(page).to have_content("Mr. Pirate")
    end
  end
end
