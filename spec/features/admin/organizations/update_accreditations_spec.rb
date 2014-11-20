require 'rails_helper'

feature 'Update accreditations' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'when no accreditations exist', :js do
    within '#s2id_organization_accreditations' do
      expect(page).to have_no_css('.select2-search-choice-close')
    end
  end

  scenario 'with one accreditation', :js do
    select2('Knight Foundation Grant', 'organization_accreditations', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@organization.reload.accreditations).to eq ['Knight Foundation Grant']
  end

  scenario 'with two accreditations', :js do
    select2('first', 'organization_accreditations', multiple: true, tag: true)
    select2('second', 'organization_accreditations', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@organization.reload.accreditations).to eq %w(first second)
  end

  scenario 'removing an accreditation', :js do
    @organization.update!(accreditations: %w(County Donations))
    visit '/admin/organizations/parent-agency'
    within '#s2id_organization_accreditations' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@organization.reload.accreditations).to eq ['Donations']
  end
end
