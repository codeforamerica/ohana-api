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
      assign_location_service_and_taxonomy_ids

      authorize @location
    end

    def update
      assign_location_service_and_taxonomy_ids

      preprocess_service_params
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

    # rubocop:disable Metrics/MethodLength
    def create
      preprocess_service_params

      @location = Location.find(params[:location_id])
      @service = @location.services.new(params[:service])
      @taxonomy_ids = []

      preprocess_service

      if @service.save
        redirect_to admin_location_path(@location),
                    notice: "Service '#{@service.name}' was successfully created."
      else
        render :new
      end
    end
    # rubocop:enable Metrics/MethodLength

    def destroy
      service = Service.find(params[:id])
      service.destroy
      redirect_to admin_locations_path
    end

    private

    def preprocess_service
      add_program_to_service_if_authorized
      add_service_to_location_if_authorized
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

    def add_service_to_location_if_authorized
      return unless location_ids.present?

      location_ids.each do |id|
        Location.find(id.to_i).services.create!(params[:service])
      end
    end

    def location_ids
      return unless params[:service][:locations].present?
      params[:service][:locations].reject do |id|
        !location_ids_for(@service).include?(id.to_i)
      end
    end

    def location_ids_for(service)
      @ids ||= service.location.organization.locations.pluck(:id)
    end

    def assign_location_service_and_taxonomy_ids
      @service = Service.find(params[:id])
      @location = Location.find(params[:location_id])
      @taxonomy_ids = @service.categories.pluck(:taxonomy_id)
    end
  end
end
