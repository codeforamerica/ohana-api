require 'rails_helper'

describe 'API Root Endpoint' do
  it 'displays links to all top-level endpoints' do
    get api_url(subdomain: ENV['API_SUBDOMAIN'])
    hash = {
      'organizations_url' => "#{api_organizations_url}{?page,per_page}",
      'organization_url' => "#{api_organizations_url}/{organization}",
      'organization_locations_url' => "#{api_url}/organizations/{organization}"\
        "/locations{?page,per_page}",
      'locations_url' => "#{api_locations_url}{?page,per_page}",
      'location_url' => "#{api_locations_url}/{location}",
      'location_search_url' => "#{api_search_index_url}{?category,email,"\
        "keyword,language,lat_lng,location,org_name,radius,service_area,"\
        "status,page,per_page}"
    }
    expect(json).to eq(hash)
  end
end
