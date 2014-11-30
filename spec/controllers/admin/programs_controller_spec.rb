require 'rails_helper'

describe Admin::ProgramsController do
  describe 'GET edit' do
    before(:each) do
      org = create(:organization)
      @program = org.programs.create!(attributes_for(:program))
    end

    context 'when admin is super admin' do
      it 'allows access to edit program' do
        log_in_as_admin(:super_admin)

        get :edit, id: @program.id

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin does not have access' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :edit, id: @program.id

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'GET new' do
    before(:each) do
      create(:location)
    end

    context 'when admin is super admin' do
      it 'allows access to add a new program' do
        log_in_as_admin(:super_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when admin does not have access' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:admin)

        get :new

        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end
end
