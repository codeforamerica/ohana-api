require 'rails_helper'

feature 'Visiting a specific organization' do
  before(:all) do
    @location = create(:location)
    @organization = @location.organization
  end

  before(:each) do
    @organization.reload
    @location.reload
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'when admin has unmatched generic email' do
    admin = create(:admin_with_generic_email)
    login_as_admin(admin)
    visit('/admin/organizations/parent-agency')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(current_path).to eq(admin_dashboard_path)
  end

  scenario 'when admin has unmatched custom domain name' do
    login_admin
    visit('/admin/organizations/parent-agency')
    expect(page).to have_content I18n.t('admin.not_authorized')
    expect(current_path).to eq(admin_dashboard_path)
  end

  scenario 'when admin has matched custom domain name' do
    @location.update!(website: 'http://samaritanhouse.com')
    login_admin
    visit('/admin/organizations/parent-agency')
    expect(page).to_not have_content I18n.t('admin.not_authorized')
    @location.update!(website: '')
  end

  scenario 'when admin is location admin' do
    new_admin = create(:admin_with_generic_email)
    @location.update!(admin_emails: [new_admin.email])
    login_as_admin(new_admin)
    visit('/admin/organizations/parent-agency')
    expect(page).to_not have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  scenario 'when admin is location admin but has non-generic email' do
    login_admin
    @location.update!(admin_emails: [@admin.email])
    visit('/admin/organizations/parent-agency')
    expect(page).to_not have_content I18n.t('admin.not_authorized')
    @location.update!(admin_emails: [])
  end

  scenario 'when admin is super admin' do
    login_super_admin
    visit('/admin/organizations/parent-agency')
    expect(page).to_not have_content I18n.t('admin.not_authorized')
  end

  context 'when admin is not super admin' do
    it 'denies access to create a new organization' do
      login_admin
      visit('/admin/organizations/new')
      expect(page).to have_content I18n.t('admin.not_authorized')
      expect(current_path).to eq(admin_dashboard_path)
      visit('/admin/organizations')
      expect(page).to_not have_link 'Add a new organization'
    end
  end
end
