require 'rails_helper'

describe 'DELETE /locations/:location_id/contacts/:contact_id/phones/:id' do
  before(:all) do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
    @phone = @contact.phones.create!(attributes_for(:phone))
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'deletes the phone' do
    delete(
      api_location_contact_phone_url(@loc, @contact, @phone, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(@contact.reload.phones.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_location_contact_phone_url(@loc, @contact, @phone, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting a phone without a valid token" do
    delete(
      api_location_contact_phone_url(@loc, @contact, @phone, subdomain: ENV['API_SUBDOMAIN']),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end
end
