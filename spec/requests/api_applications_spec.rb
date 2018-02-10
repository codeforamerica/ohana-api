require 'rails_helper'
require 'requests_helper'

describe 'ApiApplications' do
  describe 'GET /api_applications' do
    context 'when not signed in' do
      it "redirects to 'users/sign_in'" do
        get api_applications_path
        expect(response.status).to be(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      it 'returns a 200' do
        @user = FactoryBot.create(:user)
        login(@user)
        get api_applications_url
        expect(response.status).to be(200)
      end
    end
  end
end
