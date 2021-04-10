require 'rails_helper'

describe Admin::OrganizationsController do
  describe 'create' do
    let(:attrs) do
      {
        name: 'New org',
        description: 'New description',
        licenses: [''],
        accreditations: ['']
      }
    end

    context 'when admin is super admin' do
      it 'allows access to create organization' do
        log_in_as_admin(:super_admin)

        expect { post :create, params: { organization: attrs } }.to change(Organization, :count)

        expect(response).to redirect_to admin_organizations_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        expect { post :create, params: { organization: attrs } }.not_to change(Organization, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'update' do
    let(:attrs) do
      {
        name: 'Updated org',
        description: 'Updated description',
        licenses: [''],
        accreditations: ['']
      }
    end

    before do
      loc = create(:location_with_admin)
      @org = loc.organization
    end

    context 'when admin is super admin' do
      it 'allows access to update organization' do
        log_in_as_admin(:super_admin)

        post :update, params: { id: @org.id, organization: attrs }

        expect(response).to redirect_to admin_organization_url(@org.reload.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :update, params: { id: @org.id, organization: attrs }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@org.reload.name).not_to eq 'Updated organization'
      end
    end

    context 'when admin is regular admin allowed to edit this organization' do
      it 'updates the organization' do
        log_in_as_admin(:location_admin)

        post :update, params: { id: @org.id, organization: attrs }

        expect(response).to redirect_to admin_organization_url(@org.reload.friendly_id)
        expect(@org.reload.name).to eq 'Updated org'
      end
    end
  end

  describe 'destroy' do
    before do
      location = create(:location_with_admin)
      @organization = location.organization
    end

    context 'when admin is super admin' do
      it 'allows access to destroy organization' do
        log_in_as_admin(:super_admin)

        delete :destroy, params: { id: @organization.id }

        expect(response).to redirect_to admin_organizations_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect do
          delete :destroy, params: { id: @organization.id }
        end.not_to change(Organization, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin allowed to destroy this organization' do
      it 'destroys the organization' do
        log_in_as_admin(:location_admin)

        delete :destroy, params: { id: @organization.id }

        expect(response).to redirect_to admin_organizations_url
        expect(Organization.find_by(id: @organization.id)).to be_nil
      end
    end
  end

  describe 'edit' do
    before do
      location = create(:location_with_admin)
      @organization = location.organization
    end

    context 'when admin is super admin' do
      it 'allows access to destroy organization' do
        log_in_as_admin(:super_admin)

        get :edit, params: { id: @organization.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, params: { id: @organization.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin allowed to destroy this organization' do
      it 'destroys the organization' do
        log_in_as_admin(:location_admin)

        get :edit, params: { id: @organization.id }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'new' do
    context 'when admin is super admin' do
      it 'allows access to create a new organization' do
        log_in_as_admin(:super_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is not a super_admin' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end
end
