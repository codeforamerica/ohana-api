require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  describe "Admin user" do
    context "visiting the welcome page for the first time" do
      before(:example) do
        allow(WelcomeToken).to receive(:create).and_return(OpenStruct.new(code: "token"))
      end

      it "should redirect to the current page with a token code" do
        get :home
        expect(response).to redirect_to(welcome_path(code: "token"))
      end
      
    end

    context "visiting the welcome page a second time" do
      context "without a code" do
        it "should redirect to the root path" do
          create(:welcome_token)

          get :home
          expect(response).to redirect_to(root_path)
        end
      end
      context "with the wrong code" do
        it "should redirect to the root path" do
          create(:welcome_token)

          get :home, code: 12345
          expect(response).to redirect_to(root_path)
        end
      end
      context "with the right code" do
        it "should be successful" do
          token = create(:welcome_token)

          get :home, code: token.code
          expect(response).to have_http_status(200)
        end
      end
    end


  end
end
