module Api
  module V1
    class RootController < ApplicationController
      def index
        json_for_root_endpoint = {
          organizations_url: "#{api_organizations_url}{/organization_id}",
          locations_url: "#{api_locations_url}{/location_id}",
          location_search_url: "#{api_search_index_url}{?category,keyword,language,lat_lng,location,radius,org_name}"
        }
        render json: json_for_root_endpoint, status: 200
      end
    end
  end
end
