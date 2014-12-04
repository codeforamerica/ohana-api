require 'rails_helper'

describe CategoryImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_category_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_category.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/valid_category.csv').read }


  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    create(:location)
  end

  after(:all) do
    Category.delete_all
  end

  subject(:importer) { CategoryImporter.new(content) }

  describe '#valid_headers?' do
    context 'when the category headers are invalid' do
      let(:content) { invalid_header_content }

      it { is_expected.not_to be_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { is_expected.to be_valid_headers }
    end
  end
  
  describe '.import_file' do
    context 'with valid data' do
      it 'creates a category' do
        expect do
          path = Rails.root.join('spec/support/fixtures/valid_category.csv')
          CategoryImporter.import_file(path)
        end.to change(Category, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a category' do
        expect do
          path = Rails.root.join('spec/support/fixtures/invalid_category.csv')
          CategoryImporter.import_file(path)
        end.not_to change(Category, :count)
      end
    end
  end
end
