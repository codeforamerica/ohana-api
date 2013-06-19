require 'spec_helper'
require 'requests_helper'

describe "ApiApplications" do
  describe "GET /api_applications" do
    context "when not signed in" do
	    it "redirects to 'users/sign_in'" do
	    	get api_applications_path
	      response.status.should be(302)
	      response.should redirect_to(new_user_session_path)
	    end
	  end

	  context "when signed in" do
	    it "returns a 200" do
	    	@user = FactoryGirl.create(:user)
	    	login(@user)
	    	get api_applications_path
	      response.status.should be(200)
	    end
	  end
  end
end
