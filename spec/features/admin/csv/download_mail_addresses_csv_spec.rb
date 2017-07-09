require 'rails_helper'

feature 'Downloading Mail Addresses CSV' do
  before do
    @mail_address = create(:mail_address)
    visit admin_csv_mail_addresses_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w[id location_id attention address_1 address_2
                               city state_province postal_code country]
  end

  it 'populates mail address attribute values' do
    expect(csv.second).to eq [
      @mail_address.id.to_s, @mail_address.location_id.to_s, 'Monfresh',
      '1 davis dr', nil, 'Belmont', 'CA', '90210', 'US'
    ]
  end
end
