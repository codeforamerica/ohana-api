require 'rails_helper'

describe Admin::ServicesController do
  describe 'GET edit' do
    before(:each) do
      @loc = create(:nearby_loc)
      @service = @loc.services.create!(attributes_for(:service))
    end

    context 'when admin is super admin' do
      it 'allows access to edit service' do
        log_in_as_admin(:super_admin)

        get :edit, location_id: @loc.id, id: @service.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :edit, location_id: @loc.id, id: @service.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      @loc = create(:nearby_loc)
    end

    context 'when admin is super admin' do
      it 'allows access to edit service' do
        log_in_as_admin(:super_admin)

        get :new, location_id: @loc.id

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new, location_id: @loc.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'PATCH update' do
    before(:each) do
      @loc = create(:location_for_org_admin)
      @service = @loc.services.create!(attributes_for(:service))
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
        patch :update, location_id: @loc.id, id: @service.id, service: attrs

        expect(@restricted_loc.reload.services.pluck(:name)).to eq []
      end
    end

    context 'when location_id are empty' do
      it 'successfully updates the service' do
        log_in_as_admin(:admin)

        attrs = {
          name: 'Service',
          description: 'Description',
          keywords: ['']
        }
        patch :update, location_id: @loc.id, id: @service.id, service: attrs

        expect(flash[:notice]).to include('successfully updated')
      end
    end
  end
end
