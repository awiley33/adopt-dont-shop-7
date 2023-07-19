class Admin::SheltersController < ApplicationController
  
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
    @pending = Shelter.order('name')
  end

  def show
    @shelter = Shelter.find_by_sql([<<-SQL, params[:id]])
      SELECT *
      FROM shelters
      WHERE id = ?
    SQL

    
  end

end
