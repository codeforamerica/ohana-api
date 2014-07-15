require 'rails_helper'

describe 'DELETE /locations/:location_id/faxes/:id' do
  before(:all) do
    @loc = create(:location)
    @fax = @loc.faxes.create!(attributes_for(:fax))
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'deletes the fax' do
    delete(
      api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(@loc.reload.faxes.count).to eq(0)
    expect(Fax.count).to eq(0)
  end

  it 'returns a 204 status' do
    delete(
      api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
      {}
    )
    expect(response).to have_http_status(204)
  end

  it "doesn't allow deleting a fax without a valid token" do
    delete(
      api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
      {},
      'HTTP_X_API_TOKEN' => 'invalid_token'
    )
    expect(response).to have_http_status(401)
  end
end
