require 'rails_helper'

describe 'PATCH fax' do
  before(:all) do
    @loc = create(:location)
    @fax = @loc.faxes.create!(attributes_for(:fax))
  end

  before(:each) do
    @attrs = { number: '123-456-7890', department: 'Director' }
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  describe 'PATCH /locations/:location_id/faxes/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated fax when validations pass' do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(json['department']).to eq 'Director'
    end

    it "updates the location's fax" do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      get api_location_url(@loc, subdomain: ENV['API_SUBDOMAIN'])
      expect(json['faxes'].first['number']).to eq '123-456-7890'
    end

    it "doesn't add a new fax" do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(Fax.count).to eq(1)
    end

    it 'requires a valid fax id' do
      patch(
        api_location_fax_url(@loc, 123, subdomain: ENV['API_SUBDOMAIN']),
        @attrs
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs.merge!(number: '703')
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('number' => ['703 is not a valid US fax number'])
    end

    it "doesn't allow updating a fax without a valid token" do
      patch(
        api_location_fax_url(@loc, @fax, subdomain: ENV['API_SUBDOMAIN']),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
