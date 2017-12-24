require 'rails_helper'

feature 'Downloading Services CSV' do
  before { login_super_admin }

  context 'services has non-empty array attributes' do
    before do
      @food = create(:category)
      @health = create(:health)
      @jobs = create(:jobs)
      @service = create(
        :service_with_extra_whitespace,
        category_ids: [@food.id, @health.id, @jobs.id]
      )
      visit admin_csv_services_path(format: 'csv')
    end

    it 'contains the same headers as in the import Wiki' do
      expect(csv.first).to eq %w[
        id location_id program_id accepted_payments
        alternate_name application_process audience description
        eligibility email fees funding_sources
        interpretation_services keywords languages name
        required_documents service_areas status wait_time website
        taxonomy_ids
      ]
    end

    it 'converts arrays to comma-separated strings' do
      expect(csv.second).to eq [
        @service.id.to_s, @service.location_id.to_s, nil, 'Cash, Credit',
        'AKA', 'in person', 'Low-income seniors', 'SNAP market', 'seniors',
        'foo@example.com', 'none', 'County', 'CTS LanguageLink',
        'health, yoga', 'French, English', 'Benefits', 'ID', 'Belmont',
        'active', '2 days', 'http://www.monfresh.com', '101, 102, 105'
      ]
    end
  end

  context 'services has empty array attributes' do
    before do
      @service = create(:service, keywords: nil)
      visit admin_csv_services_path(format: 'csv')
    end

    it 'converts value to nil or empty string' do
      expect(csv.second).to eq [
        @service.id.to_s, @service.location_id.to_s, nil, '', nil, 'By phone.',
        nil, 'yoga classes', nil, nil, nil, '', nil, '', '',
        'Literacy Program', '', '', 'active', nil, nil, ''
      ]
    end
  end
end
