class Admin::SheltersController < ApplicationController

	def index
		@shelters = Shelter.order_by_name_alpha_reverse
	end 

	def show
		@shelter = Shelter.find(params[:id])
	end
end