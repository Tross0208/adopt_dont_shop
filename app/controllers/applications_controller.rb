class ApplicationsController < ApplicationController

  def index
    @applications = Application.all 
  end

  def new
    @application = Application.new
  end

  def create
    application = Application.create(app_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:notice] = "Error: all requested areas must be filled!"
      redirect_to "/applications/new"
    end
  end

  def show
    @application = Application.find(params[:id])
    if @application.pets_added != []
      @pets_added = @application.pets_added
    end
    if params[:search_by_name]
      @pet_found = Pet.search_by_name(params[:search_by_name])
    end
  end

  def update
    @application = Application.find(params[:id])
    if params[:description]

      @application.description = params[:description]
      @application.status = "Pending"
      @application.save
    end
    redirect_to "/applications/#{@application.id}"
  end

private

  def app_params
    params.require(:application).permit(:name, :street_address, :city, :state, :zipcode, :status, :description)
  end
end
