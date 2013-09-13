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
        {
          "organizations_url" => "#{ENV["API_BASE_URL"]}organizations{/organization_id}",
          "locations_url" => "#{ENV["API_BASE_URL"]}locations{/location_id}",
          "general_search_url" => "#{ENV["API_BASE_URL"]}search{?keyword,location,radius,language,kind,category,market_match}",
          "rate_limit_url" => "#{ENV["API_BASE_URL"]}rate_limit"
        }
      end
    end

    resource "locations" do
      # GET /locatons
      # GET /locations?page=2
      desc 'Returns all locations, 30 per page'
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
              nearby
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
      desc "Search using a variety of parameters. Returns locations.", {
        :notes =>
        <<-NOTE
          Search
          ------

          **Possible parameters**: keyword, location, radius, language, kind,
          market_match, category, page.

          When searching by `keyword`, the API returns locations where the
          search term matches one or more of these fields:

              the location's name
              the location's description
              the location's parent organization's name
              the location's services' keywords
              the location's services' name
              the location's services' descriptions
              the location's services' category names

          Results that match service categories are ranked the highest,
          followed by service keywords matches.

          Example:
          ```
          #{ENV["API_BASE_URL"]}search?keyword=food
          ```

          Queries that include the `location` parameter filter the results to
          only include locations that are 5 miles (by default) from the
          `location`.
          To search within a radius smaller or greater than 5 miles, use the
          `radius` parameter. `radius` must be a Float between 0.1 and 50.
          `location` can be an address (full or partial), or a 5-digit ZIP code.
          Results are sorted by distance.

          Examples:

          `#{ENV["API_BASE_URL"]}search?location=94403`

          `#{ENV["API_BASE_URL"]}search?location=san mateo&radius=10`

          `#{ENV["API_BASE_URL"]}search?keyword=emergency&location=94403`


          The `language` parameter can be used to filter locations by language
          spoken at the location.

          Examples:

          `#{ENV["API_BASE_URL"]}search?language=tagalog`

          `#{ENV["API_BASE_URL"]}search?location=east palo alto&language=tongan`

          `#{ENV["API_BASE_URL"]}search?keyword=daycare&language=spanish`

          The `kind` parameter can be used to filter locations by the
          overall type of organization. Possible values are:

          `human` (for Human Services)

          `market` (for Farmer's Markets)

          `other` (for those that have been flagged as neither Farmer's Market
           nor Human Service, but haven't been further categorized)

          For farmers' markets only, an additional parameter can be added to
          get a list of markets that participate in the Market Match program.

          Examples:

          `#{ENV["API_BASE_URL"]}search?kind=market&market_match=1` (to get participants)

          `#{ENV["API_BASE_URL"]}search?kind=market&market_match=0` (to get non-participants)

          The `category` parameter is used to search only on the service
          categories field using the OpenEligibility taxonomy.

          Example:

          `#{ENV["API_BASE_URL"]}search?category=emergency food`

          The search results JSON includes the location's parent organization
          info, as well as the location's services, so you can have all the
          info in one query instead of three.

          Search returns 30 results per page. Use the `page` parameter to
          get a new set of results.

          Example:

          `#{ENV["API_BASE_URL"]}search?keyword=education&page=2`

          Pagination info is available via the following HTTP response headers:

          `X-Total-Count`

          `X-Total-Pages`

          `X-Current-Page`

          `X-Next-Page`

          `X-Previous-Page`

          Pagination links are available via the `Link` header.
        NOTE
      }
      params do
        optional :keyword, type: String
        optional :location, type: String, desc: "An address or 5-digit ZIP code"
        optional :radius, type: Float, desc: "Distance in miles from the location parameter"
        optional :language, type: String, desc: "Languages other than English spoken at the location"
        optional :kind, type: String, desc: "The type of organization, such as human services, farmers' markets"
        optional :category, type: String, desc: "The service category based on the OpenEligibility taxonomy"
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
      desc "Provides rate limit info", {
        :notes =>
        <<-NOTE
          Rate Limiting
          -------------

          Requests that don't include an `X-Api-Token` header with a valid token
          are limited to 60 requests per hour. You can get a valid token by
          registering an app at http://ohanapi.herokuapp.com.

          Requests that have a valid header and token get 5000 requests per hour.

          You can check your rate limit via the `#{ENV["API_BASE_URL"]}rate_limit` endpoint,
          which won't affect your rate limit, or by examining the following
          response headers:

          `X-RateLimit-Limit` (The maximum number of requests permitted per hour.)

          `X-RateLimit-Remaining` (The number of requests remaining in the current rate limit window.)

          Once you go over the limit, you will receive a `403` response:

              HTTP/1.1 403 Forbidden
              Connection: close
              Content-Type: application/json
              Date: Thu, 12 Sep 2013 06:20:45 GMT
              Status: 403 Forbidden
              Transfer-Encoding: chunked

              {
                "description": "Rate limit exceeded",
                "hourly_rate_limit": 60,
                "method": "GET",
                "request": "http://localhost:8080/api/search",
                "status": 403
              }

          **Staying within the rate limit**

          If you are using a valid X-Api-Token, and you are exceeding
          your rate limit, you can likely fix the issue by caching API responses
          and using conditional requests.

          **Conditional requests**

          Most responses return an ETag header.
          You can use the values of that headers to make subsequent requests
          to those resources using the If-None-Match header.
          If the resource has not changed, the server will return a
          304 Not Modified and an empty body. Also note: making a conditional
          request and receiving a 304 response does not count against your
          Rate Limit, so we encourage you to use it whenever possible.
        NOTE
      }
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