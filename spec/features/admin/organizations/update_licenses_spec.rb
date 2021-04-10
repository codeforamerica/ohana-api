require 'rails_helper'

describe 'Update licenses' do
  before do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'when no licenses exist', :js do
    within '#s2id_organization_licenses' do
      expect(page).to have_no_css('.select2-search-choice-close')
    end
  end

  it 'with one license', :js do
    select2('Knight Foundation Grant', 'organization_licenses', multiple: true, tag: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq ['Knight Foundation Grant']
  end

  it 'with two licenses', :js do
    select2('first', 'organization_licenses', multiple: true, tag: true)
    select2('second', 'organization_licenses', multiple: true, tag: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq %w[first second]
  end

  it 'removing a license', :js do
    @organization.update!(licenses: %w[County Donations])
    visit '/admin/organizations/parent-agency'
    within '#s2id_organization_licenses' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq ['Donations']
  end
end
