require 'spec_helper'

describe ApiApplicationsController do
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  # This should return the minimal set of attributes required to create a valid
  # ApiApplication. As you add validations to ApiApplication, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: "test app",
                             main_url: "http://localhost:8080",
                             callback_url: "http://localhost:8080" } }

  let(:invalid_attributes) { { name: "",
                             main_url: "localhost:8080",
                             callback_url: "localhost:8080" } }

  describe "GET index" do
    it "assigns all api_applications as @api_applications" do
      api_application = @user.api_applications.create! valid_attributes
      get :index
      assigns(:api_applications).should eq([api_application])
    end
  end

  # describe "GET show" do
  #   it "assigns the requested api_application as @api_application" do
  #     api_application = @user.api_applications.create! valid_attributes
  #     get :show, :id => api_application.to_param
  #     assigns(:api_application).should eq(api_application)
  #   end
  # end

  describe "GET new" do
    it "assigns a new api_application as @api_application" do
      get :new
      assigns(:api_application).should be_a_new(ApiApplication)
    end
  end

  describe "GET edit" do
    it "assigns the requested api_application as @api_application" do
      api_application = @user.api_applications.create! valid_attributes
      get :edit, { :id => api_application.to_param }
      assigns(:api_application).should eq(api_application)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ApiApplication" do
        expect {
          post :create, { :api_application => valid_attributes }
        }.to change { @user.reload.api_applications.count }.by(1)
      end

      it "assigns a newly created api_application as @api_application" do
        post :create, { :api_application => valid_attributes }
        assigns(:api_application).should be_a(ApiApplication)
        assigns(:api_application).should be_persisted
      end

      it "redirects to the created api_application" do
        post :create, { :api_application => valid_attributes }
        response.should redirect_to(@user.reload.api_applications.last)
      end

      it "generates an access token" do
        post :create, { :api_application => valid_attributes }
        api_application = @user.reload.api_applications.last
        api_application.access_token.should_not be_blank
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved api_application as @api_application" do
        post :create, { :api_application => invalid_attributes }
        assigns(:api_application).should be_a_new(ApiApplication)
      end

      it "re-renders the 'new' template" do
        post :create, { :api_application => invalid_attributes }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested api_application" do
        api_application = @user.api_applications.create! valid_attributes
        # Assuming there are no other api_applications in the database, this
        # specifies that the ApiApplication created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        @user.api_applications.any_instance.should_receive(:update_attributes).with({ "name" => "test" })
        put :update, { :id => api_application.to_param, :api_application => { "name" => "test" } }
      end

      it "assigns the requested api_application as @api_application" do
        api_application = @user.api_applications.create! valid_attributes
        put :update, { :id => api_application.to_param, :api_application => valid_attributes }
        assigns(:api_application).should eq(api_application)
      end

      it "redirects to the api_application" do
        api_application = @user.api_applications.create! valid_attributes
        put :update, { :id => api_application.to_param, :api_application => valid_attributes }
        response.should redirect_to(api_application)
      end
    end

    describe "with invalid params" do
      it "assigns the api_application as @api_application" do
        api_application = @user.api_applications.create! valid_attributes
        put :update, { :id => api_application.to_param, :api_application => invalid_attributes }
        assigns(:api_application).should eq(api_application)
      end

      it "re-renders the 'edit' template" do
        api_application = @user.api_applications.create! valid_attributes
        put :update, { :id => api_application.to_param, :api_application => invalid_attributes }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested api_application" do
      api_application = @user.api_applications.create! valid_attributes
      expect {
        delete :destroy, { :id => api_application.to_param }
      }.to change { @user.reload.api_applications.count }.by(-1)
    end

    it "redirects to the api_applications list" do
      api_application = @user.api_applications.create! valid_attributes
      delete :destroy, { :id => api_application.to_param }
      response.should redirect_to(api_applications_url)
    end
  end
end
