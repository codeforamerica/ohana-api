require 'rails_helper'

describe ApiApplicationsController do
  before :each do
    @user = FactoryBot.create(:user)
    sign_in @user
  end
  # This should return the minimal set of attributes required to create a valid
  # ApiApplication. As you add validations to ApiApplication, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'test app',
      main_url: 'http://codeforamerica.org',
      callback_url: 'https://github.com/codeforamerica' }
  end

  let(:invalid_attributes) do
    { name: '',
      main_url: 'localhost:8080',
      callback_url: 'localhost:8080' }
  end

  describe 'GET index' do
    it 'assigns all api_applications as @api_applications' do
      api_application = @user.api_applications.create! valid_attributes
      get :index
      expect(assigns(:api_applications)).to eq([api_application])
    end
  end

  describe 'GET new' do
    it 'assigns a new api_application as @api_application' do
      get :new
      expect(assigns(:api_application)).to be_a_new(ApiApplication)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested api_application as @api_application' do
      api_application = @user.api_applications.create! valid_attributes
      get :edit, id: api_application.to_param
      expect(assigns(:api_application)).to eq(api_application)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new ApiApplication' do
        expect { post :create, api_application: valid_attributes }.
          to change { @user.reload.api_applications.count }.by(1)
      end

      it 'assigns a newly created api_application as @api_application' do
        post :create, api_application: valid_attributes
        expect(assigns(:api_application)).to be_a(ApiApplication)
        expect(assigns(:api_application)).to be_persisted
      end

      it 'redirects to the created api_application' do
        post :create, api_application: valid_attributes
        new_app = @user.reload.api_applications.last
        expect(response).
          to redirect_to edit_api_application_path(new_app)
      end

      it 'generates an access token' do
        post :create, api_application: valid_attributes
        api_application = @user.reload.api_applications.last
        expect(api_application.api_token).not_to be_blank
      end
    end

    describe 'with invalid params' do
      it 'assigns a new but unsaved api_application as @api_application' do
        post :create, api_application: invalid_attributes
        expect(assigns(:api_application)).to be_a_new(ApiApplication)
      end

      it "re-renders the 'new' template" do
        post :create, api_application: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested api_application' do
        api_application = @user.api_applications.create! valid_attributes
        put :update, id: api_application, api_application: { name: 'test' }
        api_application.reload
        expect(api_application.name).to eq('test')
      end

      it 'assigns the requested api_application as @api_application' do
        api_application = @user.api_applications.create! valid_attributes
        put(
          :update,
          id: api_application.to_param,
          api_application: valid_attributes
        )
        expect(assigns(:api_application)).to eq(api_application)
      end

      it 'redirects to the api_application' do
        api_application = @user.api_applications.create! valid_attributes
        put(
          :update,
          id: api_application.to_param,
          api_application: valid_attributes
        )
        expect(response).
          to redirect_to edit_api_application_path(api_application)
      end
    end

    describe 'with invalid params' do
      it 'assigns the api_application as @api_application' do
        api_application = @user.api_applications.create! valid_attributes
        put(
          :update,
          id: api_application.to_param,
          api_application: invalid_attributes
        )
        expect(assigns(:api_application)).to eq(api_application)
      end

      it "re-renders the 'edit' template" do
        api_application = @user.api_applications.create! valid_attributes
        put(
          :update,
          id: api_application.to_param,
          api_application: invalid_attributes
        )
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested api_application' do
      api_application = @user.api_applications.create! valid_attributes
      expect { delete :destroy, id: api_application.to_param }.
        to change { @user.reload.api_applications.count }.by(-1)
    end

    it 'redirects to the api_applications list' do
      api_application = @user.api_applications.create! valid_attributes
      delete :destroy, id: api_application.to_param
      expect(response).to redirect_to(api_applications_url)
    end
  end
end
