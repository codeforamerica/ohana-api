require 'rails_helper'

feature "Update service's program" do
  background do
    create_service
    @prog = @location.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with valid program' do
    select 'Collection of Services', from: 'service_program_id'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(page).
      to have_select('service_program_id', selected: 'Collection of Services')
    expect(@service.reload.program_id).to eq @prog.id
  end

  scenario 'with blank program' do
    @service.program_id = @prog.id
    @service.save
    select 'This service is not part of any program', from: 'service_program_id'
    click_button 'Save changes'
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_program_id').value).to eq ''
    expect(@service.reload.program_id).to be_nil
  end
end
