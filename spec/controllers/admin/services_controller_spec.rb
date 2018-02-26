require 'rails_helper'

describe Admin::ServicesController do
  describe 'GET edit' do
    before(:each) do
      @loc = create(:location_with_admin)
      @service = @loc.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to edit service' do
        log_in_as_admin(:super_admin)

        get :edit, params: { location_id: @loc.id, id: @service.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, params: { location_id: @loc.id, id: @service.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to edit service' do
        log_in_as_admin(:location_admin)

        get :edit, params: { location_id: @loc.id, id: @service.id }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      @loc = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to create service' do
        log_in_as_admin(:super_admin)

        get :new, params: { location_id: @loc.id }

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :new, params: { location_id: @loc.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to create service' do
        log_in_as_admin(:location_admin)

        get :new, params: { location_id: @loc.id }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH update' do
    before(:each) do
      @loc = create(:location_for_org_admin)
      @service = @loc.services.create!(attributes_for(:service))
      @new_loc = create(:far_loc, organization_id: @loc.organization.id)
      @restricted_loc = create(:location)
    end

    context 'when location does not belong to organization' do
      it 'does not copy the service to the location' do
        log_in_as_admin(:admin)

        attrs = {
          name: 'Service',
          description: 'Description',
          locations: [@restricted_loc.id],
          keywords: ['']
        }
        patch :update, params: { location_id: @loc.id, id: @service.id, service: attrs }

        expect(@restricted_loc.reload.services.pluck(:name)).to eq []
      end
    end

    context 'when location_ids are empty' do
      it 'successfully updates the service' do
        log_in_as_admin(:admin)

        attrs = {
          name: 'Service',
          description: 'Description',
          keywords: ['']
        }
        patch :update, params: { location_id: @loc.id, id: @service.id, service: attrs }

        expect(flash[:notice]).to include('successfully updated')
      end
    end
  end

  describe 'create' do
    before(:each) do
      @location = create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to create service' do
        log_in_as_admin(:super_admin)

        post :create, params: { location_id: @location.id, service: {
          name: 'New Service', description: 'new service', status: 'active', keywords: ['']
        } }

        expect(response).
          to redirect_to admin_location_url(@location.friendly_id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect do
          post :create, params: { location_id: @location.id, service: {
            name: 'New Service', description: 'new service', status: 'active', keywords: ['']
          } }
        end.to_not change(Service, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin allowed to create a service' do
      it 'creates the service' do
        log_in_as_admin(:location_admin)

        expect do
          post :create, params: { location_id: @location.id, service: {
            name: 'New Service', description: 'new service', status: 'active', keywords: ['']
          } }
        end.to change(Service, :count).by(1)

        expect(response).
          to redirect_to admin_location_url(@location.friendly_id)
      end
    end
  end

  describe 'update' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
      @attrs = {
        name: 'Updated Service',
        description: 'Updated Description',
        keywords: ['']
      }
    end

    context 'when admin is super admin' do
      it 'allows access to update service' do
        log_in_as_admin(:super_admin)

        post(:update, params: { location_id: @location.id, id: @service.id, service: @attrs })

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post(:update, params: { location_id: @location.id, id: @service.id, service: @attrs })

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@service.reload.name).to_not eq 'Updated Service'
      end
    end

    context 'when admin is regular admin allowed to edit this service' do
      it 'updates the service' do
        log_in_as_admin(:location_admin)

        post(:update, params: { location_id: @location.id, id: @service.id, service: @attrs })

        expect(response).
          to redirect_to admin_location_service_url(@location.friendly_id, @service.id)
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @location = create(:location_with_admin)
      @service = @location.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to destroy service' do
        log_in_as_admin(:super_admin)

        delete :destroy, params: { location_id: @location.id, id: @service.id }

        expect(response).to redirect_to admin_locations_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect { delete :destroy, params: { location_id: @location.id, id: @service.id } }.
          to_not change(Service, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin allowed to destroy this service' do
      it 'destroys the service' do
        log_in_as_admin(:location_admin)

        delete :destroy, params: { location_id: @location.id, id: @service.id }

        expect(response).to redirect_to admin_locations_url
        expect(Service.find_by(id: @service.id)).to be_nil
      end
    end
  end
end
