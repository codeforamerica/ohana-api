require 'rails_helper'

describe 'Visiting a specific organization' do
  before(:all) do
    @location = create(:location)
    @organization = @location.organization
  end

  before do
    @organization.reload
    @location.reload
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'when admin has unmatched generic email' do
    admin = create(:admin_with_generic_email)
    login_as_admin(admin)
    visit('/admin/organizations/parent-agency')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
  end

  it 'when admin has unmatched custom domain name' do
    login_admin
    visit('/admin/organizations/parent-agency')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
  end

  it 'when admin has matched custom domain name' do
    @location.update!(website: 'http://samaritanhouse.com')
    login_admin
    visit('/admin/organizations/parent-agency')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(website: '')
  end

  it 'when admin is location admin' do
    new_admin = create(:admin_with_generic_email)
    @location.update!(admin_emails: [new_admin.email])
    login_as_admin(new_admin)
    visit('/admin/organizations/parent-agency')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  it 'when admin is location admin but has non-generic email' do
    login_admin
    @location.update!(admin_emails: [@admin.email])
    visit('/admin/organizations/parent-agency')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  it 'when admin is super admin' do
    login_super_admin
    visit('/admin/organizations/parent-agency')
    expect(page).not_to have_content I18n.t('admin.not_authorized')
  end

  context 'when admin is not super admin' do
    it 'denies access to create a new organization' do
      login_admin
      visit('/admin/organizations/new')
      expect(page).to have_content I18n.t('admin.not_authorized')
      expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
      visit('/admin/organizations')
      expect(page).not_to have_link I18n.t('admin.buttons.add_organization')
    end
  end
end
