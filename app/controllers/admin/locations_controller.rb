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

      authorize @location

      if @location.update(location_params)
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
      @location = Location.new(location_params)
      org = @location.organization

      authorize org if org.present?

      if @location.save
        redirect_to [:admin, @location], notice: 'Location was successfully created.'
      else
        render :new
      end
    end

    def destroy
      location = Location.find(params[:id])

      authorize location

      location.destroy
      redirect_to admin_locations_url
    end

    private

    # rubocop:disable MethodLength
    def location_params
      params.require(:location).permit(
        :organization_id, { accessibility: [] }, :active, { admin_emails: [] },
        :alternate_name, :description, :email, { languages: [] }, :latitude,
        :longitude, :name, :short_desc, :transportation, :website, :virtual,
        address_attributes: %i[
          address_1 address_2 city state_province postal_code country id _destroy
        ],
        mail_address_attributes: %i[
          attention address_1 address_2 city state_province postal_code country id _destroy
        ],
        phones_attributes: %i[
          country_prefix department extension number number_type vanity_number id _destroy
        ],
        regular_schedules_attributes: %i[weekday opens_at closes_at id _destroy],
        holiday_schedules_attributes: %i[closed start_date end_date opens_at closes_at id _destroy]
      )
    end
    # rubocop:enable MethodLength
  end
end
