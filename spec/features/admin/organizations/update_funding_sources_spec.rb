require 'rails_helper'

feature 'Update funding_sources' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with no funding_sources' do
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq []
  end

  scenario 'with one funding source', :js do
    select2('State', 'organization_funding_sources', multiple: true)
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq ['State']
  end

  scenario 'with two funding_sources', :js do
    select2('State', 'organization_funding_sources', multiple: true)
    select2('County', 'organization_funding_sources', multiple: true)
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq %w(State County)
  end

  scenario 'removing a funding source', :js do
    @organization.update!(funding_sources: %w(State County))
    visit '/admin/organizations/parent-agency'
    within '#s2id_organization_funding_sources' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@organization.reload.funding_sources).to eq ['County']
  end
end
