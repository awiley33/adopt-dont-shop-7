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
      flash[:notice] = "Pet application has been approved."
    elsif params[:status] == "Rejected"
      @pet_application.update(status: "Rejected")
      flash[:notice] = "Pet application has been rejected."
    end

    if @application.all_pets_have_status?
      @application.update(status: "Rejected") 
      flash[:notice] = "Application has been rejected as not all pets are approved."
    end
    
    if @application.all_pets_approved?
      @application.update(status: "Approved")
      @application.adopt_all_pets 
      flash[:notice] = "Application and all associated pets have been approved."
    end

    @pet.reload
    @application.reload
    @pet_application.reload

    redirect_to "/admin/applications/#{@application.id}"
  end
end
