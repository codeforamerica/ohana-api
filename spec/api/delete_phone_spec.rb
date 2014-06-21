require 'rails_helper'

describe 'DELETE /api/locations/:location/phones/:id' do
  before(:each) do
    @loc = create(:location)
    @phone = @loc.phones.create!(attributes_for(:phone))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'deletes the phone' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(@loc.reload.phones.count).to eq(0)
    expect(Phone.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting a phone without a valid token" do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/phones/#{@phone.id}"),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end
end
