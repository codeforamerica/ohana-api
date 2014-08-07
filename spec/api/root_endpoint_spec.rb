require 'rails_helper'

describe 'API Root Endpoint' do
  it 'displays links to all top-level endpoints' do
    get api_url(subdomain: ENV['API_SUBDOMAIN'])
    hash = {
      'organizations_url' => "#{api_organizations_url}{/organization_id}",
      'locations_url' => "#{api_locations_url}{/location_id}",
      'location_search_url' => "#{api_search_index_url}{?category,keyword,language,lat_lng,location,radius,org_name}"
    }
    expect(json).to eq(hash)
  end
end
