class OrganizationsController < ApplicationController
	respond_to :json

	def index
		@organizations = Organization.all
		respond_with(@organizations)
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
		respond_with(@org)
	end
end