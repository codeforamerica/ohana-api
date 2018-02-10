require 'rails_helper'

describe Admin::OrganizationContactsController do
  describe 'GET edit' do
    before(:each) do
      location = create(:location_with_admin)
      @org = location.organization
      @contact = @org.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :edit, organization_id: @org.id, id: @contact.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges to the associated organization' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, organization_id: @org.id, id: @contact.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to edit contact' do
        log_in_as_admin(:location_admin)

        get :edit, organization_id: @org.id, id: @contact.id

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      location = create(:location_with_admin)
      @org = location.organization
    end

    context 'when admin is super admin' do
      it 'allows access to edit contact' do
        log_in_as_admin(:super_admin)

        get :new, organization_id: @org.id

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :new, organization_id: @org.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to create a new contact' do
        log_in_as_admin(:location_admin)

        get :new, organization_id: @org.id

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'create' do
    before(:each) do
      loc = create(:location)
      @org = loc.organization
    end

    context 'when admin is super admin' do
      it 'allows access to create contact' do
        log_in_as_admin(:super_admin)

        post :create, organization_id: @org.id, contact: { name: 'Jane' }

        expect(response).to redirect_to admin_organization_url(@org.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :create, organization_id: @org.id, contact: { name: 'Jane' }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@org.contacts).to be_empty
      end
    end

    context 'when admin is regular admin allowed to create a contact' do
      it 'creates the contact' do
        location = create(:location_with_admin)
        organization = location.organization
        log_in_as_admin(:location_admin)

        post :create, organization_id: organization.id, contact: { name: 'Jane' }

        expect(response).to redirect_to admin_organization_url(organization.friendly_id)
        expect(organization.contacts.last.name).to eq 'Jane'
      end
    end
  end

  describe 'update' do
    before(:each) do
      @loc = create(:location_with_admin)
      @org = @loc.organization
      @contact = @org.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to update contact' do
        log_in_as_admin(:super_admin)

        post :update, organization_id: @org.id, id: @contact.id, contact: { name: 'Jane' }

        expect(response).
          to redirect_to admin_organization_contact_url(@org.friendly_id, @contact.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :update, organization_id: @org.id, id: @contact.id, contact: { name: 'Jane' }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to_not eq 'Jane'
      end
    end

    context 'when admin is regular admin allowed to edit this contact' do
      it 'updates the contact' do
        log_in_as_admin(:location_admin)

        post :update, organization_id: @org.id, id: @contact.id, contact: { name: 'Jane' }

        expect(response).
          to redirect_to admin_organization_contact_url(@org.friendly_id, @contact.id)
        expect(@contact.reload.name).to eq 'Jane'
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @loc = create(:location_with_admin)
      @org = @loc.organization
      @contact = @org.contacts.create!(attributes_for(:contact))
    end

    context 'when admin is super admin' do
      it 'allows access to destroy contact' do
        log_in_as_admin(:super_admin)

        delete :destroy, organization_id: @org.id, id: @contact.id

        expect(response).to redirect_to admin_organization_url(@org.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        delete :destroy, organization_id: @org.id, id: @contact.id

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@contact.reload.name).to eq 'Moncef Belyamani'
      end
    end

    context 'when admin is regular admin allowed to destroy this contact' do
      it 'destroys the contact' do
        log_in_as_admin(:location_admin)

        delete :destroy, organization_id: @org.id, id: @contact.id

        expect(response).to redirect_to admin_organization_url(@org.friendly_id)
        expect(Contact.find_by(id: @contact.id)).to be_nil
      end
    end
  end
end
