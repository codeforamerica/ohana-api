require 'rails_helper'

feature 'Create a new service' do
  background do
    @loc = create(:location)
    login_super_admin
    visit('/admin/locations/vrs-services')
    click_link 'Add a new service'
  end

  scenario 'with all required fields' do
    fill_in_required_service_fields
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_name').value).to eq 'New VRS Services service'
    expect(find_field('service_description').value).to eq 'new description'
    expect(find_field('service_how_to_apply').value).to eq 'new application process'
  end

  scenario 'without any required fields' do
    click_button 'Create service'
    expect(page).to have_content "Description can't be blank for Service"
    expect(page).to have_content "Name can't be blank for Service"
    expect(page).to have_content "How to apply can't be blank for Service"
  end

  scenario 'with alternate_name' do
    fill_in_required_service_fields
    fill_in 'service_alternate_name', with: 'Alternate name'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_alternate_name').value).to eq 'Alternate name'
  end

  scenario 'with audience' do
    fill_in_required_service_fields
    fill_in 'service_audience', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_audience').value).to eq 'Low-income residents.'
  end

  scenario 'with eligibility' do
    fill_in_required_service_fields
    fill_in 'service_eligibility', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_eligibility').value).to eq 'Low-income residents.'
  end

  scenario 'with email' do
    fill_in_required_service_fields
    fill_in 'service_email', with: 'foo@bar.com'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_email').value).to eq 'foo@bar.com'
  end

  scenario 'with fees' do
    fill_in_required_service_fields
    fill_in 'service_fees', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_fees').value).to eq 'Low-income residents.'
  end

  scenario 'when adding an accepted payment', :js do
    fill_in_required_service_fields
    select2('Cash', 'service_accepted_payments', multiple: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find(:css, 'select#service_accepted_payments').value).to eq(['Cash'])
  end

  scenario 'when adding multiple funding_sources', :js do
    fill_in_required_service_fields
    select2('first', 'service_funding_sources', multiple: true, tag: true)
    select2('second', 'service_funding_sources', multiple: true, tag: true)
    click_button 'Create service'

    service = Service.find_by_name('New VRS Services service')
    expect(service.funding_sources).to eq %w(first second)
  end

  scenario 'with how_to_apply' do
    fill_in_required_service_fields
    fill_in 'service_how_to_apply', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_how_to_apply').value).to eq 'Low-income residents.'
  end

  scenario 'with status' do
    fill_in_required_service_fields
    select 'Inactive', from: 'service_status'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_status').value).to eq 'inactive'
  end

  scenario 'when adding multiple keywords', :js do
    fill_in_required_service_fields
    select2('first', 'service_keywords', multiple: true, tag: true)
    select2('second', 'service_keywords', multiple: true, tag: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    service = Service.find_by_name('New VRS Services service')
    expect(service.keywords).to eq %w(first second)
  end

  scenario 'when adding a language', :js do
    fill_in_required_service_fields
    select2('French', 'service_languages', multiple: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find(:css, 'select#service_languages').value).to eq(['French'])
  end

  scenario 'when adding a required document', :js do
    fill_in_required_service_fields
    select2('Picture ID', 'service_required_documents', multiple: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find(:css, 'select#service_required_documents').value).to eq(['Picture ID'])
  end

  scenario 'when adding a service area', :js do
    fill_in_required_service_fields
    select2('Belmont', 'service_service_areas', multiple: true)
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find(:css, 'select#service_service_areas').value).to eq(['Belmont'])
  end

  scenario 'when adding a website' do
    fill_in_required_service_fields
    fill_in 'service_website', with: 'http://ruby.com'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_website').value).to eq 'http://ruby.com'
  end

  scenario 'with wait' do
    fill_in_required_service_fields
    fill_in 'service_wait', with: 'Low-income residents.'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find_field('service_wait').value).to eq 'Low-income residents.'
  end

  scenario 'when adding categories', :js do
    emergency = Category.create!(name: 'Emergency', oe_id: '101')
    emergency.children.create!(name: 'Disaster Response', oe_id: '101-01')
    emergency.children.create!(name: 'Subcategory 2', oe_id: '101-02')
    visit('/admin/locations/vrs-services/services/new')

    fill_in_required_service_fields
    check 'category_101'
    check 'category_101-01'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(find('#category_101-01')).to be_checked
    expect(find('#category_101')).to be_checked
  end

  scenario 'when adding a program', :js do
    @loc.organization.programs.create!(attributes_for(:program))
    visit new_admin_location_service_path(@loc)
    fill_in_required_service_fields
    select 'Collection of Services', from: 'service_program_id'
    click_button 'Create service'
    click_link 'New VRS Services service'

    expect(page).
      to have_select('service_program_id', selected: 'Collection of Services')
  end

  scenario 'when adding hours of operation', :js do
    fill_in_required_service_fields
    add_hour(
      weekday: 'Tuesday',
      opens_at_hour: '9 AM', opens_at_minute: '30',
      closes_at_hour: '5 PM', closes_at_minute: '45'
    )
    click_button 'Create service'
    click_link 'New VRS Services service'

    prefix = 'service_regular_schedules_attributes_0'

    expect(find_field("#{prefix}_weekday").value).to eq '2'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq '09'
    expect(find_field("#{prefix}_opens_at_5i").value).to eq '30'

    expect(find_field("#{prefix}_closes_at_4i").value).to eq '17'
    expect(find_field("#{prefix}_closes_at_5i").value).to eq '45'
  end

  scenario 'when adding holiday schedule', :js do
    fill_in_required_service_fields
    add_holiday_schedule(
      start_month: 'January',
      start_day: '1',
      end_month: 'January',
      end_day: '2',
      closed: 'Closed'
    )
    click_button 'Create service'
    click_link 'New VRS Services service'

    prefix = 'service_holiday_schedules_attributes_0'

    expect(find_field("#{prefix}_start_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_start_date_3i").value).to eq '1'

    expect(find_field("#{prefix}_end_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_end_date_3i").value).to eq '2'

    expect(find_field("#{prefix}_closed").value).to eq 'true'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq ''
    expect(find_field("#{prefix}_opens_at_5i").value).to eq ''

    expect(find_field("#{prefix}_closes_at_4i").value).to eq ''
    expect(find_field("#{prefix}_closes_at_5i").value).to eq ''
  end
end

describe 'when admin does not have access to the location' do
  it 'denies access to create a new service' do
    create(:location)
    login_admin

    visit('/admin/locations/vrs-services/services/new')

    expect(page).to have_content I18n.t('admin.not_authorized')
  end
end
