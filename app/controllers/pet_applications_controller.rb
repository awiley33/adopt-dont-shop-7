class PetApplicationsController < ApplicationController
  def create
    @pet_application = PetApplication.create!(pet_application_params)
    redirect_to "/applications/#{@pet_application.application_id}"
  end

  private
  
  def pet_application_params
    params.permit(:pet_id, :application_id)
  end
end