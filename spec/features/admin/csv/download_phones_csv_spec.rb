require 'rails_helper'

feature 'Downloading Phones CSV' do
  before do
    login_super_admin
    @service = create(:service)
    @location = @service.location
    @org_id = @location.organization_id
    @phone = create(
      :phone,
      location_id: @location.id,
      organization_id: @org_id,
      service_id: @service.id
    )
    visit admin_csv_phones_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w[id contact_id location_id organization_id
                               service_id country_prefix department extension
                               number number_type vanity_number]
  end

  it 'populates phone attribute values' do
    expect(csv.second).to eq [
      @phone.id.to_s, nil, @location.id.to_s, @org_id.to_s, @service.id.to_s,
      nil, nil, '200', '650 851-1210', 'voice', nil
    ]
  end
end
