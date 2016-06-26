require 'rails_helper'

feature 'Downloading Addresses CSV' do
  before do
    @address = create(:address, location_id: 1)
    visit admin_csv_addresses_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w(id location_id address_1 address_2 city
                               state_province postal_code country)
  end

  it 'populates address attribute values' do
    expect(csv.second).to eq [
      @address.id.to_s, @address.location_id.to_s, '1800 Easton Drive', nil,
      'Burlingame', 'CA', '94010', 'US'
    ]
  end
end
