class Admin
  class ServicesController < ApplicationController
    include Taggable

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @services = Kaminari.paginate_array(policy_scope(Service)).
                  page(params[:page]).per(params[:per_page])
    end

    def edit
      @location = Location.find(params[:location_id])
      @service = Service.find(params[:id])
      @taxonomy_ids = @service.categories.pluck(:taxonomy_id)

      authorize @location
    end

    def update
      @service = Service.find(params[:id])
      @location = Location.find(params[:location_id])
      @taxonomy_ids = @service.categories.pluck(:taxonomy_id)

      preprocess_service

      if @service.update(params[:service])
        redirect_to [:admin, @location, @service],
                    notice: 'Service was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @location = Location.find(params[:location_id])
      @taxonomy_ids = []

      authorize @location

      @service = Service.new
    end

    def create
      preprocess_service_params

      @location = Location.find(params[:location_id])
      @service = @location.services.new(params[:service])
      @taxonomy_ids = []

      add_program_to_service_if_authorized

      if @service.save
        redirect_to admin_location_path(@location),
                    notice: "Service '#{@service.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      service = Service.find(params[:id])
      service.destroy
      redirect_to admin_locations_path
    end

    private

    def preprocess_service
      preprocess_service_params
      add_program_to_service_if_authorized
    end

    def preprocess_service_params
      shift_and_split_params(params[:service], :keywords)
    end

    def add_program_to_service_if_authorized
      prog_id = params[:service][:program_id]
      @service.program = nil and return if prog_id.blank?

      if program_ids_for(@service).select { |id| id == prog_id.to_i }.present?
        @service.program_id = prog_id
      end
    end

    def program_ids_for(service)
      service.location.organization.programs.pluck(:id)
    end
  end
end
