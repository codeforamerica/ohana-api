# require 'spec_helper'

# describe "when User-Agent is blank" do
#   before (:each) do
#     get 'api/organizations'
#   end

#   it 'returns a 403 status' do
#     response.status.should == 403
#   end

#   it 'returns a missing user agent message' do
#     json["description"].should == 'Missing or invalid User Agent string.'
#   end
# end