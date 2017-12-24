require 'rails_helper'

feature 'Downloading Organizations CSV' do
  before { login_super_admin }

  context 'organization has non-empty array attributes' do
    before do
      @org = create(:org_with_extra_whitespace)
      visit admin_csv_organizations_path(format: 'csv')
    end

    it 'contains the same headers as in the import Wiki' do
      expect(csv.first).to eq %w[
        id accreditations alternate_name date_incorporated
        description email funding_sources legal_status licenses
        name tax_id tax_status website
      ]
    end

    it 'converts arrays to comma-separated strings' do
      expect(csv.second).to eq [
        @org.id.to_s, 'BBB, AAA', 'AKA', 'April 25, 2001',
        'Organization created for testing purposes', 'foo@bar.org',
        'County, State', 'nonprofit', 'Health Bureau', 'Food Pantry', '12345',
        '501c3', 'http://cfa.org'
      ]
    end
  end

  context 'organization has nil array attributes' do
    before do
      @org = create(
        :org_with_extra_whitespace,
        accreditations: nil,
        date_incorporated: nil,
        funding_sources: nil,
        licenses: nil
      )
      visit admin_csv_organizations_path(format: 'csv')
    end

    it 'converts value to nil or empty string' do
      expect(csv.second).to eq [
        @org.id.to_s, nil, 'AKA', nil,
        'Organization created for testing purposes', 'foo@bar.org', nil,
        'nonprofit', nil, 'Food Pantry', '12345', '501c3', 'http://cfa.org'
      ]
    end
  end
end
