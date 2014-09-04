require 'rails_helper'

feature 'Update websites' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'when no websites exist' do
    expect(page).to have_no_xpath("//input[@name='organization[urls][]']")
  end

  scenario 'by adding 2 new websites', :js do
    add_two_urls
    expect(find_field('organization_urls_0').value).to eq 'http://ruby.com'
    delete_all_urls
    expect(page).to have_no_xpath("//input[@name='organization[urls][]']")
  end

  scenario 'with 2 urls but one is empty', :js do
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    click_link 'Add a new website'
    click_button 'Save changes'
    total_urls = all(:xpath, "//input[@type='url']")
    expect(total_urls.length).to eq 1
  end

  scenario 'with 2 urls but only one is invalid', :js do
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    click_link 'Add a new website'
    urls = page.
        all(:xpath, "//input[@name='organization[urls][]']")
    fill_in urls[-1][:id], with: 'Alexandria'
    click_button 'Save changes'
    total_fields_with_errors = page.all(:css, '.field_with_errors')
    expect(total_fields_with_errors.length).to eq 1
  end

  scenario 'with invalid website' do
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    fill_in 'organization_urls_0', with: 'www.monfresh.com'
    click_button 'Save changes'
    expect(page).to have_content 'www.monfresh.com is not a valid URL'
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'with valid website' do
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    fill_in 'organization_urls_0', with: 'http://codeforamerica.org'
    click_button 'Save changes'
    expect(find_field('organization_urls_0').value).
      to eq 'http://codeforamerica.org'
  end
end
