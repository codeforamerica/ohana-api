require 'rails_helper'

describe 'Update holiday schedule' do
  before do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  it 'when closed', :js do
    add_holiday_schedule(
      start_month: 'January',
      start_day: '1',
      end_month: 'January',
      end_day: '2',
      closed: 'Closed'
    )
    click_button I18n.t('admin.buttons.save_changes')

    prefix = 'location_holiday_schedules_attributes_0'

    expect(find_field("#{prefix}_start_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_start_date_3i").value).to eq '1'

    expect(find_field("#{prefix}_end_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_end_date_3i").value).to eq '2'

    expect(find_field("#{prefix}_closed").value).to eq 'true'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq ''
    expect(find_field("#{prefix}_opens_at_5i").value).to eq ''

    expect(find_field("#{prefix}_closes_at_4i").value).to eq ''
    expect(find_field("#{prefix}_closes_at_5i").value).to eq ''
  end

  it 'when open', :js do
    add_holiday_schedule(
      start_month: 'January',
      start_day: '1',
      end_month: 'January',
      end_day: '2',
      closed: 'Open',
      opens_at_hour: '10 AM', opens_at_minute: '30',
      closes_at_hour: '3 PM', closes_at_minute: '45'
    )
    click_button I18n.t('admin.buttons.save_changes')

    prefix = 'location_holiday_schedules_attributes_0'

    expect(find_field("#{prefix}_start_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_start_date_3i").value).to eq '1'

    expect(find_field("#{prefix}_end_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_end_date_3i").value).to eq '2'

    expect(find_field("#{prefix}_closed").value).to eq 'false'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq '10'
    expect(find_field("#{prefix}_opens_at_5i").value).to eq '30'

    expect(find_field("#{prefix}_closes_at_4i").value).to eq '15'
    expect(find_field("#{prefix}_closes_at_5i").value).to eq '45'
  end

  it 'removing a holiday schedule', :js do
    @location.holiday_schedules.create!(attributes_for(:holiday_schedule))
    visit '/admin/locations/vrs-services'

    prefix = 'location_holiday_schedules_attributes_0'
    expect(find_field("#{prefix}_closed").value).to eq 'true'

    click_link I18n.t('admin.buttons.remove_holiday_schedule')
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_no_field("#{prefix}_closed")
  end
end
