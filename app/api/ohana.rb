module Ohana
  class API < Grape::API

    resource 'organizations' do
      # GET /api/organizations
      # GET /api/organizations?page=2
      desc "Returns all organizations, 30 per page"
      params do
        optional :page, type: Integer
      end
      get do
        organizations = Organization.page(params[:page])
        set_link_header(organizations)
        organizations.extend OrganizationsRepresenter
        organizations
      end

      desc "Get the details for a specific organization"
      get ':id' do
        org = Organization.find(params[:id])
        org.extend OrganizationRepresenter
        org
      end

      segment '/:organization_id' do
        resource '/locations' do
          desc "Return the queried organization's locations."
          params do
            optional :page, type: Integer
          end
          get do
            org = Organization.find(params[:organization_id])
            locations = org.locations.page(params[:page])
            locations.extend LocationsRepresenter
            set_link_header(locations)
            locations
          end
        end
      end
    end


    resource 'locations' do
      # GET /api/locations
      # GET /api/locations?page=2
      desc "Returns all locations, 30 per page"
      params do
        optional :page, type: Integer
      end
      get do
        locations = Location.page(params[:page])
        locations.extend LocationsRepresenter
        set_link_header(locations)
        locations
      end

      desc "Get the details for a specific location"
      get ':id' do
        location = Location.find(params[:id])
        location.extend LocationRepresenter
        location
      end

      segment '/:locations_id' do
        resource '/nearby' do
          desc "Returns locations near the one queried."
          params do
            optional :page, type: Integer
            optional :radius, type: Float
          end
          get do
            location = Location.find(params[:locations_id])
            nearby = Location.nearby(location, params)
            #locations.extend LocationsRepresenter
            set_link_header(nearby) if location.coordinates.present?
            nearby
          end
        end
      end
    end

    resource 'search' do
      # GET /api/search?keyword={keyword}&location={loc}
      desc "Search by keyword, location, or language. Returns locations."
      params do
        optional :keyword, type: String
        optional :location, type: String, desc: "An address or 5-digit ZIP code"
        optional :radius, type: Float, desc: "Distance in miles from the location parameter"
        optional :language, type: String, desc: "Languages other than English spoken at the location"
      end
      get do
        locations = Location.search(params)
        set_link_header(locations)
        locations
      end
    end
  end
end