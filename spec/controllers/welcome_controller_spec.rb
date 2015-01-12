require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  include Requests::RequestHelpers

  describe 'A visitor' do
    context '#sign_in_first_time' do
      let(:token) { create(:welcome_token) }
      before(:each) do
        create(:admin)
      end
      it 'should redirect to the root page' do
        token
        post :sign_in_first_time, code: token.code
        expect(response).to redirect_to admin_dashboard_path
      end
      it 'should disable the token in production' do
        token
        allow(Rails.env).to receive(:production?).and_return(true)
        post :sign_in_first_time, code: token.code
        expect(WelcomeToken.first.is_active).to be false
      end
    end

    context '#start_over' do
      let(:token) { create(:welcome_token) }
      it 'should destroy all organizations' do
        token
        post :start_over, code: token.code
        expect(Organization.count).to eql 0
      end
      it 'should reset the primary key sequence of some entities' do
        token
        expect(ActiveRecord::Base.connection).to receive(:reset_pk_sequence!).exactly(7).times
        post :start_over, code: token.code
      end
    end

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
      let(:valid_content_mail_address) { fixture_file_upload('/valid_mail_address.csv','text/csv') }
      let(:valid_locations) { fixture_file_upload('/valid_location.csv','text/csv') }
      let(:valid_addresses) { fixture_file_upload('/valid_address.csv','text/csv') }
      let(:invalid_content) { fixture_file_upload('/invalid_org.csv','text/csv') }
      let(:invalid_content_type) { fixture_file_upload('/invalid_org.csv','application/pdf') }
      let(:valid_entity) { 'organization' }
      let(:invalid_entity) { 'something' }

      context 'with the wrong code' do
        it 'should redirect to the root path' do
          create(:welcome_token)
          post :upload, code: 12345
          expect(response).to redirect_to(root_path)
        end
      end
      context 'with inactive code' do
        it 'should redirect to the root path' do
          create(:welcome_token, is_active: false)
          post :upload, code: 12345
          expect(response).to redirect_to(root_path)
        end
      end
      context 'with the right code' do
        before(:each) do
          allow(Kernel).to receive(:puts).and_return(nil)
        end
        it 'should handle underscores in the entity name' do
          post :upload, code: token.code, files: [valid_content_mail_address], entity: 'mail_address'
          expect(json['message']).to match_array "Line 2: Location can't be blank for Mail Address"
        end

        context 'without an entity name' do
          it 'should fail' do
            post :upload, code: token.code, files: [valid_content], entity: nil
            expect(json['status']).to eql(400)
          end
          it 'should return an error message' do
            post :upload, code: token.code, files: [valid_content], entity: nil
            expect(json['message']).to eql 'Not a valid entity.'
          end
        end
        context 'with an invalid entity name' do
          it 'should fail' do
            post :upload, code: token.code, files: [valid_content], entity: invalid_entity
            expect(json['status']).to eql(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, files: [valid_content], entity: invalid_entity
            expect(json['message']).to eql 'Not a valid entity.'
          end
        end

        context 'with valid content' do
          it 'should be successful' do
            post :upload, code: token.code, files: [valid_content], entity: valid_entity
            expect(response).to have_http_status(200)
          end
          it 'should have an appropriate feedback message' do
            post :upload, code: token.code, files: [valid_content], entity: valid_entity
            expect(json['message']).to eql 'Successfully uploaded.'
          end
        end

        context 'with empty file' do
          it 'should fail' do
            post :upload, code: token.code, files: [nil], entity: valid_entity
            expect(json['status']).to eql(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, files: [nil], entity: valid_entity
            expect(json['message']).to eql 'Only CSV files are accepted.'
          end
        end

        context 'with invalid file type' do
          it 'should fail' do
            post :upload, code: token.code, files: [invalid_content_type], entity: valid_entity
            expect(json['status']).to eql(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, files: [invalid_content_type], entity: valid_entity
            expect(json['message']).to eql 'Only CSV files are accepted.'
          end
        end

        context 'with multiple file' do
          before(:example) do
            create(:organization, id: 1)
          end
          it 'should succeed' do
            post :upload, code: token.code, files: [valid_locations, valid_addresses], entity: 'location'
            expect(json['status']).to eql(200)
          end
          it 'should have an appropriate feedback message' do
            post :upload, code: token.code, files: [valid_locations, valid_addresses], entity: 'location'
            expect(json['message']).to eql 'Successfully uploaded.'
          end
        end

        context 'with invalid content' do
          before(:each) do
            allow(Kernel).to receive(:puts).and_return(nil)
          end
          it 'should fail' do
            post :upload, code: token.code, files: [invalid_content], entity: valid_entity
            expect(json['status']).to eql(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, files: [invalid_content], entity: valid_entity
            expect(json['message']).to match_array ["Line 2: Name can't be blank for Organization"]
          end
        end

        context 'with invalid headers' do
          before(:each) do
            allow(Kernel).to receive(:puts).and_return(nil)
          end
          it 'should fail' do
            post :upload, code: token.code, files: [invalid_content], entity: 'mail_address'
            expect(json['status']).to eql(400)
          end
          it 'should have an appropriate error message' do
            post :upload, code: token.code, files: [invalid_content], entity: 'mail_address'
            expect(json['message']).to include "city column is missing"
          end
        end

      end
    end
  end
end
