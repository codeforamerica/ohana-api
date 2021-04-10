require 'rails_helper'

describe 'Update accreditations' do
  before do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'when no accreditations exist', :js do
    within '#s2id_organization_accreditations' do
      expect(page).to have_no_css('.select2-search-choice-close')
    end
  end

  it 'with one accreditation', :js do
    select2('Knight Foundation Grant', 'organization_accreditations', multiple: true, tag: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq ['Knight Foundation Grant']
  end

  it 'with two accreditations', :js do
    select2('first', 'organization_accreditations', multiple: true, tag: true)
    select2('second', 'organization_accreditations', multiple: true, tag: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq %w[first second]
  end

  it 'removing an accreditation', :js do
    @organization.update!(accreditations: %w[County Donations])
    visit '/admin/organizations/parent-agency'
    within '#s2id_organization_accreditations' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq ['Donations']
  end
end
