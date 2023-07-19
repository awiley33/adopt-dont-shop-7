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
    @pet_application_6 = PetApplication.create!(pet: @pet_6, application: @application_3)
    @pet_application_7 = PetApplication.create!(pet: @pet_2, application: @application_3)
  end

  it "has a button which approves the application for that specific pet and makes the pet no longer be adoptable" do
    visit "/admin/applications/#{@application_4.id}"
    expect(@pet_application_4.status).to eq("Pending")

    click_button("Approve Adoption of #{@pet_6.name}")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")
    @pet_application_4.reload
    expect(@pet_application_4.status).to eq("Approved")

    expect(@pet_application_5.status).to eq("Pending")
    click_button("Approve Adoption of Luca")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")

    @pet_application_5.reload
    expect(@pet_application_5.status).to eq("Approved")
  end

  it "displays a status indicator and no button once approved" do
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

  it "has a button which rejects the application for that specific pet and the remains adoptable" do
    visit "/admin/applications/#{@application_4.id}"
    expect(@pet_application_4.status).to eq("Pending")

    click_button("Reject Adoption of #{@pet_6.name}")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")
    @pet_application_4.reload
    expect(@pet_application_4.status).to eq("Rejected")

    expect(@pet_application_5.status).to eq("Pending")
    click_button("Reject Adoption of #{@pet_5.name}")
    expect(current_path).to eq("/admin/applications/#{@application_4.id}")

    @pet_application_5.reload
    expect(@pet_application_5.status).to eq("Rejected")
  end
  
  it "displays a status indicator and no button once rejected" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Enzo" do 
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Rejected")
      click_button("Reject Adoption of Enzo")
      expect(current_path).to eq("/admin/applications/#{@application_4.id}")
      expect(page).to have_content("Rejected")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Reject Adoption of Enzo")
    end

    within "#Luca" do 
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Rejected")
      click_button("Reject Adoption of Luca")
      expect(current_path).to eq("/admin/applications/#{@application_4.id}")
      expect(page).to have_content("Rejected")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Reject Adoption of Luca")
    end
  end

  it "doesnt affect pets on other applications to approve or reject" do
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
      expect(page).to_not have_content("Rejected")
      click_button("Reject Adoption of Luca")
      expect(current_path).to eq("/admin/applications/#{@application_4.id}")
      expect(page).to have_content("Rejected")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Reject Adoption of Luca")
    end

    visit "/admin/applications/#{@application_3.id}"
    within "#Enzo" do 
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Approved")
      click_button("Approve Adoption of Enzo")
      expect(current_path).to eq("/admin/applications/#{@application_3.id}")
      expect(page).to have_content("Approved")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Approve Adoption of Enzo")
    end

    within "#Luca" do 
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("Rejected")
      click_button("Reject Adoption of Luca")
      expect(current_path).to eq("/admin/applications/#{@application_3.id}")
      expect(page).to have_content("Rejected")
      expect(page).to_not have_content("Pending")
      expect(page).to_not have_button("Reject Adoption of Luca")
    end
  end

  it "changes the status of the application to approved once all pets are approved" do
    visit "/admin/applications/#{@application_4.id}"
    expect(@application_4.status).to eq("Pending")
    click_button("Approve Adoption of #{@pet_6.name}")
    @application_4.reload
    expect(@application_4.status).to eq("Pending")
    click_button("Approve Adoption of Luca")
    @application_4.reload
    expect(@application_4.status).to eq("Approved")
  end

  it "displays the application status as approved once all pets are approved" do
    visit "/admin/applications/#{@application_4.id}"
    expect(page).to have_content("Application status: Pending")
    expect(page).to_not have_content("Application status: Approved")
    click_button("Approve Adoption of Enzo")
    click_button("Approve Adoption of Luca")
    expect(page).to have_content("Application status: Approved")
    expect(page).to_not have_content("Application status: Pending")
  end

  it "assigns the application's status as rejected if all animals have status other than pending but one or more is rejected" do
    visit "/admin/applications/#{@application_4.id}"
    expect(@application_4.status).to eq("Pending")
    click_button("Reject Adoption of #{@pet_6.name}")
    @application_4.reload
    expect(@application_4.status).to eq("Pending")
    click_button("Approve Adoption of Luca")
    @application_4.reload
    expect(@application_4.status).to eq("Rejected")
  end

  it "displays the application status as rejected if all animals have status other than pending but one or more is rejected" do
    visit "/admin/applications/#{@application_4.id}"
    expect(page).to have_content("Application status: Pending")
    expect(page).to_not have_content("Application status: Approved")
    expect(page).to_not have_content("Application status: Rejected")
    click_button("Reject Adoption of Enzo")
    click_button("Approve Adoption of Luca")
    expect(page).to have_content("Application status: Rejected")
    expect(page).to_not have_content("Application status: Approved")
    expect(page).to_not have_content("Application status: Pending")
  end

  it 'makes all pets from an application no longer adoptable once the application has been approved and that is evidenced on their show page' do
    visit "pets/#{@pet_6.id}"
    expect(page).to have_content(true)
    visit "pets/#{@pet_5.id}"
    expect(page).to have_content(true)

    visit "/admin/applications/#{@application_4.id}"
    expect(@pet_5.adoptable).to eq(true)
    expect(@pet_6.adoptable).to eq(true)
    expect(page).to have_content("Application status: Pending")
    expect(page).to_not have_content("Application status: Approved")
    click_button("Approve Adoption of Enzo")
    @pet_5.reload
    @pet_6.reload
    expect(@pet_5.adoptable).to eq(true)
    expect(@pet_6.adoptable).to eq(true)
    visit "pets/#{@pet_6.id}"
    expect(page).to have_content(true)
    visit "pets/#{@pet_5.id}"
    expect(page).to have_content(true)
    visit "/admin/applications/#{@application_4.id}"
    click_button("Approve Adoption of Luca")
    expect(page).to have_content("Application status: Approved")
    @pet_5.reload
    @pet_6.reload
    expect(@pet_5.adoptable).to eq(false)
    expect(@pet_6.adoptable).to eq(false)

    visit "pets/#{@pet_6.id}"
    expect(page).to have_content(false)
    visit "pets/#{@pet_5.id}"
    expect(page).to have_content(false)
  end

  it "no longer shows an option to adopt on a pending application once that pet has been adopted via an approved application" do
    visit "/admin/applications/#{@application_4.id}"
    click_button("Approve Adoption of Enzo")
    click_button("Approve Adoption of Luca")
    @pet_5.reload
    @pet_6.reload

    visit "/admin/applications/#{@application_3.id}"

    within "#Enzo" do 
      expect(page).to have_content("This pet is no longer available for adoption.")
      expect(page).to_not have_button("Approve Adoption of Enzo")
      expect(page).to have_button("Reject Adoption of Enzo")
    end

    within "#Luca" do 
      expect(page).to have_content("This pet is no longer available for adoption.")
      expect(page).to_not have_button("Approve Adoption of Luca")
      expect(page).to have_button("Reject Adoption of Luca")
    end

    within "#Clawdia" do 
      expect(page).to_not have_content("This pet is no longer available for adoption.")
      expect(page).to have_button("Approve Adoption of Clawdia")
      expect(page).to have_button("Reject Adoption of Clawdia")
    end
  end

  it "approves a pet application and shows flash notice" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Luca" do
      click_button "Approve Adoption of Luca"
    end

    expect(page).to have_content("Pet application has been approved.")
  end

  it "rejects a pet application and shows flash notice" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Luca" do
      click_button "Reject Adoption of Luca"
    end

    expect(page).to have_content("Pet application has been rejected.")
  end

  it "approves an application and shows flash notice" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Luca" do
      click_button "Approve Adoption of Luca"
    end

    within "#Enzo" do
      click_button "Approve Adoption of Enzo"
    end

    expect(page).to have_content("Application and all associated pets have been approved.")
  end

  it "rejects an application and shows flash notice" do
    visit "/admin/applications/#{@application_4.id}"

    within "#Luca" do
      click_button "Reject Adoption of Luca"
    end

    within "#Enzo" do
      click_button "Reject Adoption of Enzo"
    end

    expect(page).to have_content("Application has been rejected as not all pets are approved.")
  end
end
