class Admin
  class ServicesController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @admin_decorator = AdminDecorator.new(current_admin)
      @services = Kaminari.paginate_array(@admin_decorator.services).
                          page(params[:page]).per(params[:per_page])
    end

    def edit
      @location = Location.find(params[:location_id])
      @service = Service.find(params[:id])
      @admin_decorator = AdminDecorator.new(current_admin)
      @oe_ids = @service.categories.pluck(:oe_id)

      unless @admin_decorator.allowed_to_access_location?(@location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @service = Service.find(params[:id])
      @location = Location.find(params[:location_id])
      @oe_ids = @service.categories.pluck(:oe_id)

      add_program_to_service_if_authorized

      shift_and_split_params(params[:service])

      respond_to do |format|
        if @service.update(params[:service])
          format.html do
            redirect_to [:admin, @location, @service],
                        notice: 'Service was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      @admin_decorator = AdminDecorator.new(current_admin)
      @location = Location.find(params[:location_id])
      @oe_ids = []

      unless @admin_decorator.allowed_to_access_location?(@location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @service = Service.new
    end

    def create
      shift_and_split_params(params[:service])

      @location = Location.find(params[:location_id])
      @service = @location.services.new(params[:service])
      @oe_ids = []

      add_program_to_service_if_authorized

      respond_to do |format|
        if @service.save
          format.html do
            redirect_to admin_location_path(@location),
                        notice: "Service '#{@service.name}' was successfully created."
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      service = Service.find(params[:id])
      service.destroy
      respond_to do |format|
        format.html { redirect_to admin_locations_path }
      end
    end

    def confirm_delete_service
      @service_name = params[:service_name]
      @service_id = params[:service_id]
      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def shift_and_split_params(params)
      [:funding_sources, :keywords].each do |key|
        params[key] = params[key].shift.split(',')
      end
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
