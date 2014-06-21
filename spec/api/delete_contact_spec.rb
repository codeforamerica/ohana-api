require 'rails_helper'

describe 'DELETE /locations/:location_id/contacts/:id' do
  before(:each) do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'deletes the contact' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(@loc.reload.contacts.count).to eq(0)
    expect(Contact.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting a contact without a valid token" do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/contacts/#{@contact.id}"),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end
end
