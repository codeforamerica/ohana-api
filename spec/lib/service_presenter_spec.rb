require 'rails_helper'

describe ServicePresenter do
  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  let(:properties) do
    {
      id: '1',
      location_id: '1',
      name: 'Literacy Program',
      description: 'Example description',
      how_to_apply: 'Call',
      status: 'active'
    }
  end

  subject(:presenter) { ServicePresenter.new(properties) }

  describe '#to_service' do
    context 'when the service is valid' do
      it 'initializes a new service' do
        service = presenter.to_service
        expect { service.save! }.to change(Service, :count).by(1)
      end
    end

    context 'when the service is not valid' do
      let(:properties) do
        {
          id: '1',
          location_id: '1',
          description: 'Example description'
        }
      end

      it 'does not create a new service' do
        service = presenter.to_service
        expect { service.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when the service already exists' do
      before do
        DatabaseCleaner.clean_with(:truncation)
        create(:service)
      end

      it 'does not create a new service' do
        service = presenter.to_service
        expect { service.save! }.not_to change(Service, :count)
      end
    end

    context 'when the service has comma-separated field values' do
      let(:properties) do
        {
          id: '1',
          location_id: '1',
          name: 'Literacy Program',
          description: 'Example description',
          how_to_apply: 'Call',
          status: 'active',
          accepted_payments: 'one ,two',
          funding_sources: 'donations, grants ',
          keywords: ' foo, bar ',
          languages: 'English, Spanish',
          required_documents: 'Passport',
          service_areas: 'Atherton, Belmont'
        }
      end

      it 'transforms accepted_payments' do
        service = presenter.to_service
        expect(service.attributes['accepted_payments']).to eq %w(one two)
      end

      it 'transforms funding_sources' do
        service = presenter.to_service
        expect(service.attributes['funding_sources']).to eq %w(donations grants)
      end

      it 'transforms keywords' do
        service = presenter.to_service
        expect(service.attributes['keywords']).to eq %w(foo bar)
      end

      it 'transforms languages' do
        service = presenter.to_service
        expect(service.attributes['languages']).to eq %w(English Spanish)
      end

      it 'transforms required_documents' do
        service = presenter.to_service
        expect(service.attributes['required_documents']).to eq %w(Passport)
      end

      it 'transforms service_areas' do
        service = presenter.to_service
        expect(service.attributes['service_areas']).to eq %w(Atherton Belmont)
      end
    end

    context 'when the service has nil field values' do
      let(:properties) do
        {
          id: '1',
          location_id: '1',
          name: 'Example service',
          description: 'Example description',
          accepted_payments: nil,
          funding_sources: nil,
          keywords: nil,
          languages: nil,
          required_documents: nil,
          service_areas: nil
        }
      end

      it 'set accepted_payments to empty array' do
        service = presenter.to_service
        expect(service.attributes['accepted_payments']).to eq []
      end

      it 'set funding_sources to empty array' do
        service = presenter.to_service
        expect(service.attributes['funding_sources']).to eq []
      end

      it 'set keywords to empty array' do
        service = presenter.to_service
        expect(service.attributes['keywords']).to eq []
      end

      it 'set languages to empty array' do
        service = presenter.to_service
        expect(service.attributes['languages']).to eq []
      end

      it 'set required_documents to empty array' do
        service = presenter.to_service
        expect(service.attributes['required_documents']).to eq []
      end

      it 'set service_areas to empty array' do
        service = presenter.to_service
        expect(service.attributes['service_areas']).to eq []
      end
    end
  end
end
