require 'rails_helper'

describe 'DELETE /locations/:location_id/mail_address/:id' do
  before(:each) do
    @mail_address = create(:mail_address)
    @loc = @mail_address.location
  end

  it 'deletes the mail_address' do
    delete(
      api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(@loc.reload.mail_address).to be_nil
    expect(MailAddress.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting an mail_address without a valid token" do
    delete(
      api_location_mail_address_url(@loc, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end

  it "doesn't delete the mail_address if the location & mail_address IDs don't match" do
    delete(
      api_location_mail_address_url(1234, @mail_address, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(404)
    expect(json['message']).
      to eq('The requested resource could not be found.')
  end
end
