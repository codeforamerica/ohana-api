class Admin
  class LocationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @admin_decorator = AdminDecorator.new(current_admin)
      if current_admin.super_admin?
        @locations = Location.page(params[:page]).per(params[:per_page]).
                             order('created_at DESC')
      else
        @locations = @admin_decorator.locations
        @org = @locations.includes(:organization).first.organization if @locations.present?
      end
    end

    def new
      @location = Location.new
      @org = current_admin.org
      if @org.present?
        @location_url = @org.locations.map(&:urls).uniq.first
      else
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
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

    def create
      @location = Location.new(params[:location])

      respond_to do |format|
        if @location.save
          @org = @location.organization
          format.html do
            redirect_to admin_locations_url,
                        notice: 'Location was successfully created.'
          end
        else
          @org = current_admin.org
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
