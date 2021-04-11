require 'rails_helper'

describe 'Downloading Regular Schedules CSV' do
  before do
    login_super_admin
    create_service
    @regular_schedule = @location.regular_schedules.
                        create!(attributes_for(:regular_schedule))
    visit admin_csv_regular_schedules_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w[id location_id service_id weekday opens_at
                               closes_at]
  end

  it 'formats the date and time values' do
    expect(csv.second).to eq [
      @regular_schedule.id.to_s, @location.id.to_s, nil, 'Sunday', '09:30',
      '17:00'
    ]
  end
end
