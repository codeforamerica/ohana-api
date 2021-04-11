require 'rails_helper'

describe 'Visiting a specific location' do
  before(:all) do
    @location = create(:location)
  end

  before do
    @location.reload
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it "when location doesn't include generic email" do
    admin = create(:admin_with_generic_email)
    login_as_admin(admin)
    visit('/admin/locations/vrs-services')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
  end

  it "when location doesn't include domain name" do
    login_admin
    visit('/admin/locations/vrs-services')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
  end

  it 'when location includes domain name' do
    @location.update!(website: 'http://samaritanhouse.com')
    login_admin
    visit('/admin/locations/vrs-services')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(website: '')
  end

  it 'when admin is location admin' do
    new_admin = create(:admin_with_generic_email)
    @location.update!(admin_emails: [new_admin.email])
    login_as_admin(new_admin)
    visit('/admin/locations/vrs-services')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  it 'when admin is location admin but has non-generic email' do
    login_admin
    @location.update!(admin_emails: [@admin.email])
    visit('/admin/locations/vrs-services')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  it 'when admin is super admin' do
    login_super_admin
    visit('/admin/locations/vrs-services')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
  end

  context "when admin doesn't belong to any locations" do
    it 'denies access to create a new location' do
      login_admin
      visit('/admin/locations/new')
      expect(page).to have_content I18n.t('admin.not_authorized')
      expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
      visit('/admin/locations')
      expect(page).not_to have_link I18n.t('admin.buttons.add_location')
    end
  end

  context 'when admin is super_admin' do
    it 'allows access to create a new location' do
      Organization.find_each(&:destroy)
      login_super_admin
      visit('/admin/locations/new')
      expect(page).to have_css(
        'input#org-name[type="hidden"][data-placeholder="Choose an organization"]',
        visible: false
      )
    end
  end
end
