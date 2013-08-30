module Ohana
  class API < Grape::API

    resource "/" do
      # GET /
      desc "Provides hypermedia links to all top-level endpoints"
      get do
        {
          "organizations_url" => "http://ohanapi.herokuapp.com/api/organizations{/organization_id}",
          "locations_url" => "http://ohanapi.herokuapp.com/api/locations{/location_id}",
          "general_search_url" => "http://ohanapi.herokuapp.com/api/search{?keyword,location,radius,language}"
        }
      end
    end

    resource 'organizations' do
      # GET /organizations
      # GET /organizations?page=2
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
            set_link_header(locations)
            locations.extend LocationsRepresenter
            locations
          end
        end
      end
    end


    resource 'locations' do
      # GET /locations
      # GET /locations?page=2
      desc "Returns all locations, 30 per page"
      params do
        optional :page, type: Integer
      end
      get do
        locations = Location.page(params[:page])
        set_link_header(locations)
        locations.extend LocationsRepresenter
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
      # GET /search?keyword={keyword}&location={loc}
      desc "Search by keyword, location, or language. Returns locations.", {
        :notes =>
        <<-NOTE
          Search
          ------

          **Required parameters**: one of keyword, location, or language

          When searching by `keyword`, the API returns locations where the
          search term matches one or more of these fields:

              the location's name
              the location's description
              the location's parent organization's name
              the location's service's keywords
              the location's service's name
              the location's service's descriptions

          Results that match services keywords appear higher.

          Queries that include `location` filter the results to only include
          locations that are 5 miles (by default) from the `location`.
          To search within a radius smaller or greater than 5 miles, use the
          `radius` parameter.
          `location` can be an address (full or partial), or a 5-digit ZIP code.
          Results are sorted by distance.

          The search results JSON includes the location's parent organization
          info, as well as the location's services, so you can have all the
          info in one query instead of three.

          Search returns 30 results per page. Use the `page` parameter to
          get a new set of results.

          The total results count is available in the HTTP Response via the
          `X-Total` header, and the pagination information is available via
          the `Link` header.
        NOTE
      }
      params do
        optional :keyword, type: String
        optional :location, type: String, desc: "An address or 5-digit ZIP code"
        optional :radius, type: Float, desc: "Distance in miles from the location parameter"
        optional :language, type: String, desc: "Languages other than English spoken at the location"
        optional :page, type: Integer
      end
      get do
        locations = Location.search(params)
        set_link_header(locations)
        locations
      end
    end

    resource "rate_limit" do
      # GET /rate_limit
      desc "Provides rate limit info"
      get do
        token = request.env["HTTP_X_API_TOKEN"].to_s
        limit = (token.present? && User.where('api_applications.api_token' => token).exists?) ? 5000 : 60
        {
          "rate" => {
            "limit" => limit,
            "remaining" => limit - (REDIS.get("throttle:#{request.ip}:#{Time.now.strftime('%Y-%m-%dT%H')}")).to_i
          }
        }
      end
    end
  end
end