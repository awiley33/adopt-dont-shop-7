class Admin::ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    @pet_applications = @application.pet_applications
  end
  
  def update
    @application = Application.find(params[:id])
    @pet_application = PetApplication.find(params[:pet_application_id])
    @pet = Pet.find(params[:pet_id])

    if params[:status] == "Approved"
      @pet_application.update(status: "Approved")
    elsif params[:status] == "Rejected"
      @pet_application.update(status: "Rejected")
    end
    @application.update(status: "Rejected") if @application.all_pets_have_status?
    @application.update(status: "Approved") && @application.adopt_all_pets if @application.all_pets_approved?

    @pet.reload
    @application.reload
    @pet_application.reload

    redirect_to "/admin/applications/#{@application.id}"
  end
end
