require 'rails_helper'

describe Admin::ProgramsController do
  describe 'GET edit' do
    before do
      location = create(:location_with_admin)
      org = location.organization
      @program = org.programs.create!(attributes_for(:program))
    end

    context 'when admin is super admin' do
      it 'allows access to edit program' do
        log_in_as_admin(:super_admin)

        get :edit, params: { id: @program.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :edit, params: { id: @program.id }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to edit program' do
        log_in_as_admin(:location_admin)

        get :edit, params: { id: @program.id }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET new' do
    before do
      create(:location_with_admin)
    end

    context 'when admin is super admin' do
      it 'allows access to add a new program' do
        log_in_as_admin(:super_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'allows access to create a program' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when admin is regular admin with privileges' do
      it 'allows access to create a program' do
        log_in_as_admin(:location_admin)

        get :new

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'create' do
    before do
      loc = create(:location_with_admin)
      @org = loc.organization
    end

    context 'when admin is super admin' do
      it 'allows access to create program' do
        log_in_as_admin(:super_admin)

        post :create, params: { program: { name: 'New program', organization_id: @org.id } }

        expect(response).to redirect_to admin_programs_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect do
          post :create, params: { program: { name: 'New program', organization_id: @org.id } }
        end.not_to change(Program, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@org.programs).to be_empty
      end
    end

    context 'when admin is regular admin included in location admin_emails' do
      it 'allows program creation' do
        log_in_as_admin(:location_admin)

        post :create, params: { program: { name: 'New program', organization_id: @org.id } }

        expect(response).to redirect_to admin_programs_url
      end
    end
  end

  describe 'update' do
    before do
      loc = create(:location_with_admin)
      org = loc.organization
      @program = org.programs.create!(name: 'New Program')
    end

    context 'when admin is super admin' do
      it 'allows access to update program' do
        log_in_as_admin(:super_admin)

        post :update, params: { id: @program.id, program: { name: 'Updated program' } }

        expect(response).to redirect_to admin_program_url(@program.id)
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        post :update, params: { id: @program.id, program: { name: 'Updated program' } }

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
        expect(@program.reload.name).not_to eq 'Updated program'
      end
    end

    context 'when admin is regular admin allowed to edit this program' do
      it 'updates the program' do
        log_in_as_admin(:location_admin)

        post :update, params: { id: @program.id, program: { name: 'Updated program' } }

        expect(response).to redirect_to admin_program_url(@program.id)
        expect(@program.reload.name).to eq 'Updated program'
      end
    end
  end

  describe 'destroy' do
    before do
      loc = create(:location_with_admin)
      org = loc.organization
      @program = org.programs.create!(name: 'New Program')
    end

    context 'when admin is super admin' do
      it 'allows access to destroy program' do
        log_in_as_admin(:super_admin)

        delete :destroy, params: { id: @program.id }

        expect(response).to redirect_to admin_programs_url
      end
    end

    context 'when admin is regular admin without privileges' do
      it 'redirects to admin dashboard' do
        create(:location_for_org_admin)
        log_in_as_admin(:admin)

        expect { delete :destroy, params: { id: @program.id } }.not_to change(Program, :count)

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end

    context 'when admin is a regular admin who is allowed to destroy this program' do
      it 'destroys the program' do
        log_in_as_admin(:location_admin)

        delete :destroy, params: { id: @program.id }

        expect(response).to redirect_to admin_programs_url
        expect(Program.find_by(id: @program.id)).to be_nil
      end
    end
  end
end
