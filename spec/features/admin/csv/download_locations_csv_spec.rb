require 'rails_helper'

feature 'Downloading Locations CSV' do
  context 'location has non-empty array attributes' do
    before do
      @loc = create(
        :loc_with_extra_whitespace,
        accessibility: [:tape_braille, :disabled_parking],
        payments: %w(Cash Credit),
        products: %w(Eggs Produce)
      )
      visit admin_csv_locations_path(format: 'csv')
    end

    it 'contains the same headers as in the import Wiki + SMC fields' do
      expect(csv.first).to eq %w(
        id organization_id accessibility admin_emails alternate_name
        description email hours kind languages latitude longitude market_match
        name payments products short_desc transportation website virtual
      )
    end

    it 'converts arrays to comma-separated strings' do
      expect(csv.second).to eq [
        @loc.id.to_s, @loc.organization_id.to_s,
        'tape_braille, disabled_parking', 'foo@bar.com',
        nil, 'Provides job training', 'bar@foo.com', nil, 'Other',
        'English, Vietnamese', '37.583939', '-122.3715745', 'false',
        'VRS Services', 'Cash, Credit', 'Eggs, Produce',
        'Provides job training.', 'BART stop 1 block away.',
        'http://samaritanhouse.com', 'false'
      ]
    end
  end

  context 'location has nil array attributes' do
    before do
      @loc = create(
        :location,
        accessibility: nil, languages: nil, admin_emails: nil, payments: nil,
        products: nil
      )
      visit admin_csv_locations_path(format: 'csv')
    end

    it 'converts value to nil or empty string' do
      expect(csv.second).to eq [
        @loc.id.to_s, @loc.organization_id.to_s, '', '', nil,
        'Provides jobs training', nil, nil, 'Other', nil, '37.583939',
        '-122.3715745', 'false', 'VRS Services', '', '', nil,
        nil, nil, 'false'
      ]
    end
  end
end
