require 'rails_helper'

describe Admin::LocationsController do
  describe 'create' do
    before do
      location = create(:location_with_admin)
      @org = location.organization
    end

    context 'when admin is super admin' do
      it 'allows access to create location' do
        log_in_as_admin(:super_admin)

        post :create, params: {
          location: {
            name: 'New Location', description: 'New description', virtual: true,
            organization_id: @org.id
          }
        }

        location = Location.find_by(name: 'New Location')
        expect(response).to redirect_to admin_location_url(location)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        location_params = {
          name: 'New Location', description: 'New description', virtual: true,
          organization_id: @org.id
        }

        expect do
          post :create, params: { location: location_params }
        end.not_to change(Location, :count)
        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows location creation' do
        log_in_as_admin(:location_admin)

        post :create, params: {
          location: {
            name: 'New Location',
            description: 'New description',
            virtual: true,
            admin_emails: %w[moncef@smcgov.org],
            organization_id: @org.id
          }
        }

        location = Location.find_by(name: 'New Location')
        expect(response).to redirect_to admin_location_url(location)
      end
    end
  end

  describe 'update' do
    before do
      @loc = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to update location' do
        log_in_as_admin(:super_admin)

        post :update, params: { id: @loc.id, location: { name: 'Updated location' } }

        expect(response).to redirect_to admin_location_url(@loc.reload.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :update, params: { id: @loc.id, location: { name: 'Updated location' } }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@loc.reload.name).not_to eq 'Updated location'
      end
    end

    context 'when admin is regular admin allowed to edit this location' do
      it 'updates the location' do
        log_in_as_admin(:location_admin)

        post :update, params: { id: @loc.id, location: { name: 'Updated location' } }

        expect(response).to redirect_to admin_location_url(@loc.reload.friendly_id)
        expect(@loc.reload.name).to eq 'Updated location'
      end
    end
  end

  describe 'destroy' do
    before do
      @location = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to destroy location' do
        log_in_as_admin(:super_admin)

        delete :destroy, params: { id: @location.id }

        expect(response).to redirect_to admin_locations_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect { delete :destroy, params: { id: @location.id } }.not_to change(Location, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin allowed to destroy this location' do
      it 'destroys the location' do
        log_in_as_admin(:location_admin)

        delete :destroy, params: { id: @location.id }

        expect(response).to redirect_to admin_locations_url
        expect(Location.find_by(id: @location.id)).to be_nil
      end
    end
  end

  describe 'edit' do
    before do
      @location = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to edit location' do
        log_in_as_admin(:super_admin)

        get :edit, params: { id: @location.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, params: { id: @location.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to edit location' do
        log_in_as_admin(:location_admin)

        get :edit, params: { id: @location.id }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'new' do
    before do
      location = create(:location_with_admin)
      @org = location.organization
    end

    context 'when admin is super admin' do
      it 'allows access to add location' do
        log_in_as_admin(:super_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when admin does not have access to any locations' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to add new location' do
        log_in_as_admin(:location_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end
  end
end
