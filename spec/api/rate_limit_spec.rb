require 'spec_helper'

describe Ohana::API do

  describe "GET /rate_limit" do
    include DefaultUserAgent

    before { get "api/rate_limit" }

    it "displays your limit" do
      expect(response).to be_success
      json["rate"]["limit"].should == 60
    end

    it "displays your remaining requests" do
      expect(response).to be_success
      json["rate"]["remaining"].should == 60
    end

    it 'returns the requests limit headers' do
      headers['X-RateLimit-Limit'].should == "60"
    end

    it 'does not decrease the remaining requests' do
      headers['X-RateLimit-Remaining'].should == "60"
    end
  end

end