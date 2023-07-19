require 'rails_helper'

RSpec.describe "/admin/shelters show page" do
  before :each do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
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
end