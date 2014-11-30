require 'rails_helper'

feature 'Update funding_sources' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'when no funding_sources exist', :js do
    within '#s2id_organization_funding_sources' do
      expect(page).to have_no_css('.select2-search-choice-close')
    end
  end

  scenario 'with one funding_source', :js do
    select2('Knight Foundation Grant', 'organization_funding_sources', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq ['Knight Foundation Grant']
  end

  scenario 'with two funding_sources', :js do
    select2('first', 'organization_funding_sources', multiple: true, tag: true)
    select2('second', 'organization_funding_sources', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq %w(first second)
  end

  scenario 'removing a funding_source', :js do
    @organization.update!(funding_sources: %w(County Donations))
    visit '/admin/organizations/parent-agency'
    within '#s2id_organization_funding_sources' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq ['Donations']
  end
end
