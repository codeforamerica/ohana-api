require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  include Requests::RequestHelpers

  describe 'Admin user' do
    context 'visiting welcome home' do
      context 'when there is no welcome token in the system' do
        before(:example) do
          allow(WelcomeToken).to receive(:create).and_return(OpenStruct.new(code: 'token'))
        end
        it 'should redirect to the welcome root page with a token code' do
          get :home
          expect(response).to redirect_to(welcome_path(code: 'token'))
        end
      end

      context 'when there is a welcome token' do
        let(:token) { create(:welcome_token) }

        context 'without a code' do
          it 'should redirect to the root path' do
            token
            get :home
            expect(response).to redirect_to(root_path)
          end
        end

        context 'with the wrong code' do
          it 'should redirect to the root path' do
            token
            get :home, code: 12345
            expect(response).to redirect_to(root_path)
          end
        end

        context 'with the right code' do
          it 'should be successful' do
            get :home, code: token.code
            expect(response).to have_http_status(200)
          end
        end
      end
    end


    context 'uploading files to the server' do
      let(:token) { create(:welcome_token) }
      let(:valid_content) { fixture_file_upload('/valid_org.csv','text/csv') }
      let(:invalid_content) { fixture_file_upload('/invalid_org.csv','text/csv') }
      let(:valid_entity) { 'organization' }
      let(:invalid_entity) { 'something' }

      context 'with the wrong code' do
        it 'should redirect to the root path' do
          create(:welcome_token)
          post :upload, code: 12345
          expect(response).to redirect_to(root_path)
        end
      end
      context 'with the right code' do
        context 'without an entity name' do
          it 'should fail' do
            post :upload, code: token.code, file: valid_content, entity: nil
            expect(response).to have_http_status(400)
          end
          it 'should return an error message' do
            post :upload, code: token.code, file: valid_content, entity: nil
            expect(json['message']).to eql 'Not a valid entity.'
          end
        end
        context 'with an invalid entity name' do
          it 'should fail' do
            post :upload, code: token.code, file: valid_content, entity: invalid_entity
            expect(response).to have_http_status(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, file: valid_content, entity: invalid_entity
            expect(json['message']).to eql 'Not a valid entity.'
          end
        end
        context 'with valid content' do
          it 'should be successful' do
            post :upload, code: token.code, file: valid_content, entity: valid_entity
            expect(response).to have_http_status(200)
          end
          it 'should have an appropriate feedback message' do
            post :upload, code: token.code, file: valid_content, entity: valid_entity
            expect(json['message']).to eql 'Success.'
          end
        end
        context 'with invalid content' do
          it 'should fail' do
            post :upload, code: token.code, file: invalid_content, entity: valid_entity
            expect(response).to have_http_status(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, file: invalid_content, entity: valid_entity
            expect(json['message']).to match_array ["Line 2: Name can't be blank for Organization"]
          end
        end
      end
    end
  end
end
