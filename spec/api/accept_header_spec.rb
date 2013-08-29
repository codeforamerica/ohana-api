require 'spec_helper'

describe "Version in Accept Header" do
  context "Accept Header is properly formatted" do
    before :each do
      organization = create(:organization)
      get 'api/organizations', {},
        { 'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json',
          'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => "Rspec" }
    end

    it "returns a successful response" do
      expect(response).to be_success
    end

    it "retrieves a content-type of json" do
      headers['Content-Type'].should include 'application/json'
    end
  end

  context "Accept Header is not properly formatted" do
    before :each do
      organization = create(:organization)
      get 'api/organizations', {},
        { 'HTTP_ACCEPT' => 'application/vnd.ohanapi.v1+json',
          'HTTP_ORIGIN' => 'http://ohanapi.org', 'HTTP_USER_AGENT' => "Rspec" }
    end

    # This is probably a bug with Grape. It's returning a 404 instead.
    # In other cases, it returns a 500.
    # See this issue: https://github.com/intridea/grape/issues/464
    xit "returns a 406 response" do
      expect(response).to eq(400)
    end
  end
end