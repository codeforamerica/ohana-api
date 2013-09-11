require "garner/mixins/rack"

module Ohana
  class API < Grape::API

    helpers Garner::Mixins::Rack
    use Rack::ConditionalGet
    use Rack::ETag

    resource "/" do
      # GET /
      desc "Provides hypermedia links to all top-level endpoints"
      get do
        base_url = Rails.application.routes.url_helpers.root_url
        {
          "organizations_url" => "#{base_url}organizations{/organization_id}",
          "locations_url" => "#{base_url}locations{/location_id}",
          "general_search_url" => "#{base_url}search{?keyword,location,radius,language}"
        }
      end
    end

    resource "locations" do
      # GET /locatons
      # GET /loctions?page=2
      desc 'Returns all locations'
      params do
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer
      end
      get do
        #garner.options(expires_in: 15.minutes) do
          locations = Location.search(params)
          #locations = Location.includes([:organization, :services]).page(params[:page]).per(params[:per_page])
          set_link_header(locations)
          #present(locations, with: Entities::Location)
          locations
        #end
      end

      desc "Get the details for a specific location"
      get ':id' do
        #garner.options(expires_in: 5.minutes) do
          location = Location.find(params[:id])
          present location, with: Entities::Location
          # location = present location, with: Entities::Location
          # location.as_json
        #end
      end

      desc "Update a location"
      params do
        requires :id, type: String, desc: "Location ID"
      end
      put ':id' do
        authenticate!
        loc = Location.find(params[:id])
        params = request.params.except(:route_info)
        loc.update_attributes!(params)
        present loc, with: Entities::Location
      end

      segment '/:locations_id' do
        resource '/nearby' do
          desc "Returns locations near the one queried."
          params do
            optional :page, type: Integer, default: 1
            optional :radius, type: Float
          end

          get do
            #garner.options(expires_in: 15.minutes) do
              location = Location.find(params[:locations_id])
              nearby = Location.nearby(location, params)
              set_link_header(nearby) if location.coordinates.present?
              present nearby, with: Entities::Location
              # nearby = present nearby, with: Entities::Location
              # nearby.as_json
            #end
          end
        end
      end
    end

    resource 'organizations' do
      # GET /organizations
      # GET /organizations?page=2
      desc "Returns all organizations, 30 per page"
      params do
        optional :page, type: Integer, default: 1
      end
      get do
        #garner.options(expires_in: 15.minutes) do
          orgs = Organization.page(params[:page])
          set_link_header(orgs)
          present orgs, with: Organization::Entity
          # orgs = present orgs, with: Organization::Entity
          # orgs.as_json
        #end
      end

      desc "Get the details for a specific organization"
      get ':id' do
        #garner.options(expires_in: 5.minutes) do
          org = Organization.find(params[:id])
          present org, with: Organization::Entity
          # org = present org, with: Organization::Entity
          # org.as_json
        #end
      end

      segment '/:organization_id' do
        resource '/locations' do
          desc "Return the queried organization's locations."
          params do
            optional :page, type: Integer, default: 1
          end
          get do
            #garner.options(expires_in: 15.minutes) do
              org = Organization.find(params[:organization_id])
              locations = org.locations.page(params[:page])
              set_link_header(locations)
              present locations, with: Entities::Location
              #locations = present locations, with: Entities::Location
              #locations.as_json
            #end
          end
        end
      end
    end

    resource 'services' do
      segment '/:services_id' do
        resource '/categories' do
          desc "Replace all categories for a service"
          params do
            requires :category_ids, type: Array
          end
          put do
            authenticate!
            s = Service.find(params[:services_id])
            s.category_ids = params[:category_ids]
            s.save
            s
          end
        end
        resource '/keywords' do
          desc "Add one or more keywords to a service"
          params do
            requires :keywords, type: Array
          end
          post do
            authenticate!
            s = Service.find(params[:services_id])
            params[:keywords].each do |k|
              s.keywords << k unless s.keywords.include? k
            end
            s.save
            s
          end
        end
      end
    end

    resource 'categories' do
      # GET /categories
      desc "Returns all categories"
      get do
        garner.bind(Category) do
          Category.page(1).per(400)
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
        optional :page, type: Integer, default: 1
      end
      get do
        locations = Location.search(params)
        set_link_header(locations)
        #present(locations, with: Entities::Location)
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