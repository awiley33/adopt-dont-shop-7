class Admin::ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    @pet_applications = @application.pet_applications
  end
  
  def update
    @application = Application.find(params[:id])
    @pet_application = PetApplication.find(params[:pet_application_id])
    @pet = Pet.find(params[:pet_id])
    @pet.update(adoptable: false)
    @pet_application.update(status: "Approved")
    @pet_application.reload
    @pet.reload
    redirect_to "/admin/applications/#{@application.id}"
  end
end
