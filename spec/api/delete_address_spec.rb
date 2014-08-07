require 'rails_helper'

describe 'DELETE /locations/:location/address/:id' do
  before(:all) do
    @loc = create(:location)
  end

  before(:each) do
    @loc.reload
    @address = @loc.address
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'deletes the address' do
    @loc.create_mail_address!(attributes_for(:mail_address))
    delete(
      api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(@loc.reload.address).to be_nil
    expect(Address.count).to eq(0)
  end

  it 'returns a 204 status' do
    @loc.create_mail_address!(attributes_for(:mail_address))
    delete(
      api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting an address without a valid token" do
    delete(
      api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end

  it "doesn't delete the address if a mailing address isn't present" do
    delete(
      api_location_address_url(@loc, @address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(422)
    expect(json['errors'].first['address']).
      to eq(['A location must have at least one address type.'])
  end

  it "doesn't delete the address if the location & address IDs don't match" do
    delete(
      api_location_address_url(123, @address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end
end
