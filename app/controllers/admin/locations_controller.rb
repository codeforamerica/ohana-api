class Admin
  class LocationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @admin_decorator = AdminDecorator.new(current_admin)
      @locations = Kaminari.paginate_array(@admin_decorator.locations).
                           page(params[:page]).per(params[:per_page])
    end

    def edit
      @admin_decorator = AdminDecorator.new(current_admin)
      @location = Location.find(params[:id])
      @org = @location.organization

      unless @admin_decorator.allowed_to_access_location?(@location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @location = Location.find(params[:id])
      @org = @location.organization
      @admin_decorator = AdminDecorator.new(current_admin)

      respond_to do |format|
        if @location.update(params[:location])
          format.html do
            redirect_to [:admin, @location],
                        notice: 'Location was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      @location = Location.new
      @admin_decorator = AdminDecorator.new(current_admin)
      @orgs = @admin_decorator.orgs

      unless @orgs.present?
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def create
      @admin_decorator = AdminDecorator.new(current_admin)
      @orgs = @admin_decorator.orgs
      org_id = params[:location][:organization_id]

      @location = Location.new(params[:location])

      if @orgs.select { |org| org[0] == org_id.to_i }.present?
        @location.organization = Organization.find(org_id)
      end

      respond_to do |format|
        if @location.save
          format.html { redirect_to admin_locations_url, notice: 'Location was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      location = Location.find(params[:id])
      location.destroy
      respond_to do |format|
        format.html { redirect_to admin_locations_path }
      end
    end

    def confirm_delete_location
      @loc_name = params[:loc_name]
      @org_name = params[:org_name]
      @location_id = params[:location_id]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
