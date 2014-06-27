require 'rails_helper'

describe 'API Root Endpoint' do
  it 'displays links to all top-level endpoints' do
    get api_endpoint
    hash = {
      'organizations_url' => "#{api_endpoint}/organizations{/organization_id}",
      'locations_url' => "#{api_endpoint}/locations{/location_id}",
      'location_search_url' => "#{api_endpoint}/search{?category,keyword,language,lat_lng,location,radius,org_name}"
    }
    expect(json).to eq(hash)
  end
end
