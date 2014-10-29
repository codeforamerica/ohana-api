require 'rails_helper'

feature 'Update hours' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid hours', :js do
    add_hour(
      weekday: 'Tuesday',
      opens_at_hour: '9 AM', opens_at_minute: '30',
      closes_at_hour: '5 PM', closes_at_minute: '45'
    )
    click_button 'Save changes'

    prefix = 'location_regular_schedules_attributes_0'

    expect(find_field("#{prefix}_weekday").value).to eq '2'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq '09'
    expect(find_field("#{prefix}_opens_at_5i").value).to eq '30'

    expect(find_field("#{prefix}_closes_at_4i").value).to eq '17'
    expect(find_field("#{prefix}_closes_at_5i").value).to eq '45'
  end

  scenario 'removing an hour', :js do
    @location.regular_schedules.create!(attributes_for(:regular_schedule))
    visit '/admin/locations/vrs-services'

    prefix = 'location_regular_schedules_attributes_0'
    expect(find_field("#{prefix}_weekday").value).to eq '1'

    within '.hours' do
      click_link 'x'
    end
    click_button 'Save changes'

    expect(page).to have_no_field("#{prefix}_weekday")
  end
end
