require 'rails_helper'

describe 'DELETE /api/locations/:location/faxes/:id' do
  before(:each) do
    @loc = create(:location)
    @fax = @loc.faxes.create!(attributes_for(:fax))
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'deletes the fax' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/faxes/#{@fax.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(@loc.reload.faxes.count).to eq(0)
    expect(Fax.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/faxes/#{@fax.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting a fax without a valid token" do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/faxes/#{@fax.id}"),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end
end
