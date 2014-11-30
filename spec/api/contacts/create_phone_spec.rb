require 'rails_helper'

describe 'POST /locations/:location_id/contacts/:contact_id/phones' do
  before(:all) do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
  end

  before(:each) do
    @phone_attributes = { number: '123-456-7890', number_type: 'voice' }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'creates a phone with valid attributes' do
    post(
      api_location_contact_phones_url(@loc, @contact, subdomain: ENV['API_SUBDOMAIN']),
      @phone_attributes
    )
    expect(response.status).to eq(201)
    expect(json['number']).to eq(@phone_attributes[:number])
  end

  it 'only creates a phone for the contact, not the location' do
    post(
      api_location_contact_phones_url(@loc, @contact, subdomain: ENV['API_SUBDOMAIN']),
      @phone_attributes
    )
    expect(@loc.reload.phones.count).to eq 0
  end

  it "doesn't create a phone with invalid attributes" do
    post(
      api_location_contact_phones_url(@loc, @contact, subdomain: ENV['API_SUBDOMAIN']),
      number: '703', number_type: 'fax'
    )
    expect(response.status).to eq(422)
    expect(json['errors'].first['number']).
      to eq(['703 is not a valid US phone or fax number'])
  end

  it "doesn't allow creating a phone without a valid token" do
    post(
      api_location_contact_phones_url(@loc, @contact, subdomain: ENV['API_SUBDOMAIN']),
      @phone_attributes,
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end

  it 'creates a second phone for the specified contact' do
    @contact.phones.create!(@phone_attributes)
    post(
      api_location_contact_phones_url(@loc, @contact, subdomain: ENV['API_SUBDOMAIN']),
      number: '789-456-1234', department: 'cfo', number_type: 'voice'
    )
    get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
    expect(json['contacts'][0]['phones'].length).to eq 2
    expect(json['contacts'][0]['phones'][1]['department']).to eq 'cfo'
  end
end
