require 'rails_helper'

feature 'Downloading Contacts CSV' do
  before do
    @service = create(:service)
    @location = @service.location
    @org_id = @location.organization_id
    @contact = create(
      :contact_with_extra_whitespace,
      location_id: @location.id,
      organization_id: @org_id,
      service_id: @service.id)
    visit admin_csv_contacts_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w(id location_id organization_id service_id name
                               title email department)
  end

  it 'populates contact attribute values' do
    expect(csv.second).to eq [
      @contact.id.to_s, @location.id.to_s, @org_id.to_s, @service.id.to_s,
      'Foo', 'Bar', 'foo@bar.com', 'Screening']
  end
end
