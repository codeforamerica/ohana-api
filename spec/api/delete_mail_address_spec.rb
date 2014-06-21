require 'rails_helper'

describe 'DELETE /api/locations/:location/mail_address' do
  before(:each) do
    @loc = create(:no_address)
    @mail_address = @loc.mail_address
    @token = ENV['ADMIN_APP_TOKEN']
  end

  it 'deletes the mail_address' do
    @loc.create_address!(attributes_for(:address))
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/mail_address/#{@mail_address.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(@loc.reload.mail_address).to be_nil
    expect(MailAddress.count).to eq(0)
  end

  it 'returns a 204 status' do
    @loc.create_address!(attributes_for(:address))
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/mail_address/#{@mail_address.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting an mail_address without a valid token" do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/mail_address/#{@mail_address.id}"),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end

  it "doesn't delete the mail_address if an address isn't present" do
    delete(
      api_endpoint(path: "/locations/#{@loc.id}/mail_address/#{@mail_address.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(422)
    expect(json['errors'].first['mail_address']).
      to eq(['A location must have at least one address type.'])
  end

  it "doesn't delete the mail_address if the location & mail_address IDs don't match" do
    delete(
      api_endpoint(path: "/locations/123/mail_address/#{@mail_address.id}"),
      {},
      'HTTP_X_API_TOKEN' => @token
    )
    expect(response).to have_http_status(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end
end
