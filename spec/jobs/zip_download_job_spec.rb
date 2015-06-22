require 'webmock/rspec'

describe ZipDownloadJob, job: true do
  describe '#perform' do
    let(:tmp_file_name) { 'archive.zip' }
    let(:url_prefix) { 'http://example.com/admin/csv/' }
    let(:csv_downloader) { double('CsvDownloader') }

    it 'calls CsvDownloader' do
      stub_request(:any, /.*example.*/)

      allow(csv_downloader).to receive(:create_zip_archive).and_return true

      expect(CsvDownloader).to receive(:new).with(tmp_file_name, url_prefix).
        and_return(csv_downloader)

      ZipDownloadJob.new.perform(tmp_file_name, url_prefix)
    end
  end
end
