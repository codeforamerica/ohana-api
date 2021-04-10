require 'rails_helper'

describe "Update a location's accessibility options" do
  before(:all) do
    @location = create(:soup_kitchen)
  end

  before do
    @location.reload
    login_super_admin
    visit '/admin/locations/soup-kitchen'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  it "when location doesn't have any options" do
    all('input[type=checkbox]').each do |checkbox|
      expect(checkbox).not_to be_checked
    end
  end

  it 'when adding an option' do
    check 'location_accessibility_elevator'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).
      to have_content 'Location was successfully updated.'
    expect(find('#location_accessibility_elevator')).to be_checked
    reset_accessibility
  end

  it 'when removing an option' do
    check 'location_accessibility_restroom'
    click_button I18n.t('admin.buttons.save_changes')
    visit '/admin/locations/soup-kitchen'
    uncheck 'location_accessibility_restroom'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).
      to have_content 'Location was successfully updated.'
    expect(find('#location_accessibility_restroom')).not_to be_checked
  end

  it 'when adding all options' do
    set_all_accessibility
    visit '/admin/locations/soup-kitchen'
    within('.accessibility') do
      all('input[type=checkbox]').each do |checkbox|
        expect(checkbox).to be_checked unless checkbox[:id].match('accessibility').nil?
      end
    end
    reset_accessibility
  end
end
