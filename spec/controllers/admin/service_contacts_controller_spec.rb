require 'rails_helper'

describe Admin::ServiceContactsController do
  describe 'GET edit' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
      @contact = @service.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :edit,
            params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit,
            params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:location_admin)

        get :edit, params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to create contact' do
        log_in_as_admin(:super_admin)

        get :new, params: { location_id: @location.id, service_id: @service.id }

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :new, params: { location_id: @location.id, service_id: @service.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to create contact' do
        log_in_as_admin(:location_admin)

        get :new, params: { location_id: @location.id, service_id: @service.id }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'create' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to create contact' do
        log_in_as_admin(:super_admin)

        post :create,
             params: {
               location_id: @location.id, service_id: @service.id, contact: { name: 'Jane' }
             }

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :create,
             params: {
               location_id: @location.id, service_id: @service.id, contact: { name: 'Jane' }
             }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@service.contacts).to be_empty
      end
    end

    context 'when admin is regular admin allowed to create a contact' do
      it 'creates the contact' do
        log_in_as_admin(:location_admin)

        post :create,
             params: {
               location_id: @location.id, service_id: @service.id, contact: { name: 'Jane' }
             }

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
        expect(@service.contacts.last.name).to eq 'Jane'
      end
    end
  end

  describe 'update' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
      @contact = @service.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to update contact' do
        log_in_as_admin(:super_admin)

        post(
          :update,
          params: {
            location_id: @location.id,
            service_id: @service.id,
            id: @contact.id,
            contact: { name: 'Jane' }
          }
        )

        location = @location.friendly_id
        service = @service.id
        contact = @contact.id

        expect(response).
          to redirect_to admin_location_service_contact_url(location, service, contact)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post(
          :update,
          params: {
            location_id: @location.id,
            service_id: @service.id,
            id: @contact.id,
            contact: { name: 'Jane' }
          }
        )

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to_not eq 'Jane'
      end
    end

    context 'when admin is regular admin allowed to edit this contact' do
      it 'updates the contact' do
        log_in_as_admin(:location_admin)

        post(
          :update,
          params: {
            location_id: @location.id,
            service_id: @service.id,
            id: @contact.id,
            contact: { name: 'Jane' }
          }
        )

        location = @location.friendly_id
        service = @service.id
        contact = @contact.id

        expect(response).
          to redirect_to admin_location_service_contact_url(location, service, contact)
        expect(@contact.reload.name).to eq 'Jane'
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
      @contact = @service.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to destroy contact' do
        log_in_as_admin(:super_admin)

        delete :destroy,
               params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        delete :destroy,
               params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to eq 'Moncef Belyamani'
      end
    end

    context 'when admin is regular admin allowed to destroy this contact' do
      it 'destroys the contact' do
        log_in_as_admin(:location_admin)

        delete :destroy,
               params: { location_id: @location.id, service_id: @service.id, id: @contact.id }

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
        expect(Contact.find_by(id: @contact.id)).to be_nil
      end
    end
  end
end
