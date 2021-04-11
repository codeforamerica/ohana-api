require 'rails_helper'

describe 'Downloading Programs CSV' do
  before do
    login_super_admin
    @program = create(:program)
    visit admin_csv_programs_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w[id organization_id alternate_name name]
  end

  it 'populates program attribute values' do
    expect(csv.second).to eq [
      @program.id.to_s, @program.organization_id.to_s, 'Also Known As',
      'Collection of Services'
    ]
  end
end
