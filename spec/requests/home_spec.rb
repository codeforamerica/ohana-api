require 'rails_helper'

describe 'Home' do
  context 'when visit non-api path with valid Accept header' do
    before :each do
      get '/', {}, 'HTTP_ACCEPT' => 'application/vnd.ohanapi+json; version=1'
    end

    it "doesn't throw a 500 error due to ActionView::MissingTemplate" do
      expect(response.status).to eq(406)
    end
  end
end
