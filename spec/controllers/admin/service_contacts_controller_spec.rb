require 'rails_helper'

describe Admin::ServiceContactsController do
  describe 'GET edit' do
    before(:each) do
      create_service
      @contact = @service.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :edit, location_id: @location.id, service_id: @service.id, id: @contact.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :edit, location_id: @location.id, service_id: @service.id, id: @contact.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      create_service
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :new, location_id: @location.id, service_id: @service.id

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new, location_id: @location.id, service_id: @service.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end
end
