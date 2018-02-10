require 'rails_helper'

describe Admin::ContactsController do
  describe 'GET edit' do
    before(:each) do
      @loc = create(:location_with_admin)
      @contact = @loc.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :edit, location_id: @loc.id, id: @contact.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, location_id: @loc.id, id: @contact.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access' do
        log_in_as_admin(:location_admin)

        get :edit, location_id: @loc.id, id: @contact.id

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      @loc = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :new, location_id: @loc.id

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :new, location_id: @loc.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access' do
        log_in_as_admin(:location_admin)

        get :new, location_id: @loc.id

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'create' do
    before(:each) do
      @loc = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to create contact' do
        log_in_as_admin(:super_admin)

        post :create, location_id: @loc.id, contact: { name: 'John' }

        expect(response).to redirect_to admin_location_url(@loc.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        post :create, location_id: @loc.id, contact: { name: 'John' }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@loc.contacts).to be_empty
      end
    end

    context 'when admin is regular admin allowed to create a contact' do
      it 'creates the contact' do
        log_in_as_admin(:location_admin)

        post :create, location_id: @loc.id, contact: { name: 'John' }

        expect(response).to redirect_to admin_location_url(@loc.friendly_id)
        expect(@loc.contacts.last.name).to eq 'John'
      end
    end
  end

  describe 'update' do
    before(:each) do
      @loc = create(:location_with_admin)
      @contact = @loc.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to update contact' do
        log_in_as_admin(:super_admin)

        post :update, location_id: @loc.id, id: @contact.id, contact: { name: 'John' }

        expect(response).
          to redirect_to admin_location_contact_url(@loc.friendly_id, @contact.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        post :update, location_id: @loc.id, id: @contact.id, contact: { name: 'John' }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to_not eq 'John'
      end
    end

    context 'when admin is regular admin allowed to edit this contact' do
      it 'updates the contact' do
        log_in_as_admin(:location_admin)

        post :update, location_id: @loc.id, id: @contact.id, contact: { name: 'John' }

        expect(response).
          to redirect_to admin_location_contact_url(@loc.friendly_id, @contact.id)
        expect(@contact.reload.name).to eq 'John'
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @loc = create(:location_with_admin)
      @contact = @loc.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to destroy contact' do
        log_in_as_admin(:super_admin)

        delete :destroy, location_id: @loc.id, id: @contact.id

        expect(response).to redirect_to admin_location_url(@loc.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        delete :destroy, location_id: @loc.id, id: @contact.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to eq 'Moncef Belyamani'
      end
    end

    context 'when admin is regular admin allowed to destroy this contact' do
      it 'destroys the contact' do
        log_in_as_admin(:location_admin)

        delete :destroy, location_id: @loc.id, id: @contact.id

        expect(response).to redirect_to admin_location_url(@loc.friendly_id)
        expect(Contact.find_by(id: @contact.id)).to be_nil
      end
    end
  end
end
