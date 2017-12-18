require 'rails_helper'

describe 'PATCH /locations/:location_id/services/:id' do
  before(:all) do
    create_service
  end

  before(:each) do
    @attrs = attributes_for(:service_with_extra_whitespace)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  let(:expected_attributes) do
    {
      accepted_payments: %w[Cash Credit],
      alternate_name: 'AKA',
      audience: 'Low-income seniors',
      description: 'SNAP market',
      eligibility: 'seniors',
      email: 'foo@example.com',
      fees: 'none',
      funding_sources: %w[County],
      application_process: 'in person',
      interpretation_services: 'CTS LanguageLink',
      keywords: %w[health yoga],
      languages: %w[French English],
      name: 'Benefits',
      required_documents: %w[ID],
      service_areas: %w[Belmont],
      status: 'active',
      website: 'http://www.monfresh.com',
      wait_time: '2 days'
    }
  end

  let(:array_attributes) do
    %w[accepted_payments funding_sources keywords languages required_documents service_areas]
  end

  it 'returns 200 when validations pass' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(response).to have_http_status(200)
    expected_attributes.each do |key, value|
      expect(json[key.to_s]).to eq value
    end
  end

  it "updates the location's service" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    get api_location_url(@location, subdomain: ENV['API_SUBDOMAIN'])
    expect(json['services'].first['description']).to eq expected_attributes[:description]
  end

  it "doesn't add a new service" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(Service.count).to eq(1)
  end

  it 'requires a valid service id' do
    patch(
      api_location_service_url(@location, 123, subdomain: ENV['API_SUBDOMAIN']),
      @attrs
    )
    expect(response.status).to eq(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end

  it 'returns 422 when attribute is invalid' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(service_areas: ['Belmont, CA'])
    )
    expect(response.status).to eq(422)
    expect(json['message']).to eq('Validation failed for resource.')
    expect(json['errors'].first['service_areas'].first).
      to eq('Belmont, CA is not a valid service area')
  end

  it 'does not change current value of Array attributes if passed in value is an empty String' do
    location = create(:nearby_loc)
    service = location.services.create!(attributes_for(:service_with_extra_whitespace))
    patch(
      api_location_service_url(location, service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs.merge!(
        accepted_payments: '',
        funding_sources: '',
        keywords: '',
        languages: '',
        required_documents: '',
        service_areas: ''
      )
    )
    expect(response.status).to eq(200)
    array_attributes.each do |array_attribute|
      expect(json[array_attribute]).to eq expected_attributes[array_attribute.to_sym]
    end
  end

  it "doesn't allow updating a service without a valid token" do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      @attrs,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
  end

  it 'updates search index when service changes' do
    patch(
      api_location_service_url(@location, @service, subdomain: ENV['API_SUBDOMAIN']),
      description: 'fresh tunes for the soul'
    )
    get api_search_index_url(keyword: 'yoga', subdomain: ENV['API_SUBDOMAIN'])
    expect(headers['X-Total-Count']).to eq '0'
  end
end
