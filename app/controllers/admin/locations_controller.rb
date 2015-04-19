class Admin
  class LocationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @locations = Kaminari.paginate_array(policy_scope(Location)).
                   page(params[:page]).per(params[:per_page])
    end

    def edit
      @location = Location.find(params[:id])
      @org = @location.organization

      authorize @location
    end

    def update
      @location = Location.find(params[:id])
      @org = @location.organization

      if @location.update(params[:location])
        redirect_to [:admin, @location],
                    notice: 'Location was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @location = Location.new
      authorize @location
    end

    def create
      @location = Location.new(params[:location])

      assign_location_to_org(policy_scope(Organization))

      if @location.save
        redirect_to [:admin, @location], notice: 'Location was successfully created.'
      else
        render :new
      end
    end

    def destroy
      location = Location.find(params[:id])
      location.destroy
      redirect_to admin_locations_path
    end

    private

    def assign_location_to_org(admin_orgs)
      org_id = params[:location][:organization_id]

      if admin_orgs.select { |org| org[0] == org_id.to_i }.present?
        @location.organization = Organization.find(org_id)
      end
    end
  end
end
