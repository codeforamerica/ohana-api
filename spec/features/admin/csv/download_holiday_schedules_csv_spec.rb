require 'rails_helper'

feature 'Downloading Holiday Schedules CSV' do
  context 'when holiday_schedule contains nil date attributes' do
    before do
      create_service
      @holiday_schedule = @location.holiday_schedules.
                          create!(attributes_for(:holiday_schedule))
      visit admin_csv_holiday_schedules_path(format: 'csv')
    end

    it 'contains the same headers as in the import Wiki' do
      expect(csv.first).to eq %w[id location_id service_id start_date end_date
                                 closed opens_at closes_at]
    end

    it 'populates holiday_schedule attribute values' do
      expect(csv.second).to eq [
        @holiday_schedule.id.to_s, @location.id.to_s, nil,
        'December 24, 2014', 'December 24, 2014', 'true', nil, nil
      ]
    end
  end

  context 'when holiday_schedule contains non-empty date attributes' do
    before do
      create_service
      @holiday_schedule = @location.holiday_schedules.
                          create!(attributes_for(:holiday_schedule, :open))
      visit admin_csv_holiday_schedules_path(format: 'csv')
    end

    it 'formats the date and time values' do
      expect(csv.second).to eq [
        @holiday_schedule.id.to_s, @location.id.to_s, nil,
        'December 24, 2014', 'December 24, 2014', 'false', '09:00', '17:00'
      ]
    end
  end
end
