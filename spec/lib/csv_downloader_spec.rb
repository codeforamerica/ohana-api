require 'webmock/rspec'

describe CsvDownloader do
  describe '#create_zip_archive' do
    let(:tmp_file_name) { 'tmp/archive.zip' }
    let(:url_prefix) { 'http://example.com/admin/csv/' }

    after(:each) { File.delete(tmp_file_name) }

    it 'creates a zip file in the tmp_file_name path' do
      stub_request(:any, /.*example.*/)

      CsvDownloader.new(tmp_file_name, url_prefix).create_zip_archive

      expect(File.exist?(tmp_file_name)).to eq true
    end
  end
end
