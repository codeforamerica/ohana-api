require 'rails_helper'

describe 'Update phones' do
  before do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  it 'when no phones exist' do
    within('.phones') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[extension]")]')
    end

    expect(page).not_to have_link I18n.t('admin.buttons.delete_phone')
  end

  it 'by adding a new phone', :js do
    add_phone(
      number: '123-456-7890',
      number_type: 'TTY',
      department: 'Director of Development',
      extension: '1234',
      vanity_number: '123-ABC-DEFG'
    )
    click_button I18n.t('admin.buttons.save_changes')
    visit '/admin/organizations/parent-agency'

    expect(find_field('organization_phones_attributes_0_number').value).
      to eq '123-456-7890'

    expect(find_field('organization_phones_attributes_0_number_type').value).
      to eq 'tty'

    expect(find_field('organization_phones_attributes_0_department').value).
      to eq 'Director of Development'

    expect(find_field('organization_phones_attributes_0_extension').value).
      to eq '1234'

    expect(find_field('organization_phones_attributes_0_vanity_number').value).
      to eq '123-ABC-DEFG'

    delete_phone
    visit '/admin/organizations/parent-agency'
    within('.phones') do
      expect(page).
        to have_no_xpath('.//input[contains(@name, "[vanity_number]")]')
    end
  end

  it 'with 2 phones but one is empty', :js do
    add_phone(
      number: '123-456-7890',
      department: 'Director of Development',
      number_type: 'Voice'
    )
    click_link I18n.t('admin.buttons.add_phone')
    click_button I18n.t('admin.buttons.save_changes')

    within('.phones') do
      total_phones = all(:xpath, './/input[contains(@name, "[number]")]')
      expect(total_phones.length).to eq 1
    end
  end

  it 'with 2 phones but second one is invalid', :js do
    add_phone(
      number: '123-456-7890',
      department: 'Director of Development',
      number_type: 'Voice'
    )
    click_link I18n.t('admin.buttons.add_phone')
    within('.phones') do
      all_phones = all(:xpath, './/input[contains(@name, "[department]")]')
      fill_in all_phones[-1][:id], with: 'Department'
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Number can't be blank for Phone"
  end
end

describe 'Update phones' do
  before(:all) do
    @organization = create(:organization)
    @organization.phones.create!(attributes_for(:phone).merge!(extension: ''))
  end

  before do
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it 'initial state of phone type' do
    expect(find_field('organization_phones_attributes_0_number_type')).
      to have_text 'Voice'
  end

  it 'select options for number type' do
    expect(page).
      to have_select 'organization_phones_attributes_0_number_type',
                     with_options: %w[TTY Voice Fax Hotline SMS]
  end

  it 'with an empty number' do
    update_phone(number: '')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Number can't be blank for Phone"
  end

  it 'with an invalid number' do
    update_phone(number: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US phone or fax number'
  end

  it 'with an invalid extension' do
    update_phone(number: '703-555-1212', extension: 'x200')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'extension is not a number'
  end

  it 'with an empty extension' do
    update_phone(number: '703-555-1212', extension: '')
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).not_to have_content 'extension is not a number'
  end
end
