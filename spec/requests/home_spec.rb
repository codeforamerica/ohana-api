require 'spec_helper'

describe 'Home' do
  include DefaultUserAgent

  context 'when visit non-api path with valid Accept header' do

    before :each do
      get '/', {}, 'HTTP_ACCEPT' => 'application/vnd.ohanapi-v1+json'
    end

    it "doesn't throw a 500 error due to ActionView::MissingTemplate" do
      response.status.should == 406
    end
  end
end
