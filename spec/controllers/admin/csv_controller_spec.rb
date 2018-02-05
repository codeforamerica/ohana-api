require 'rails_helper'

describe Admin::CsvController do
  describe 'GET all' do
    let(:tmp_file_name) { Rails.root.join('tmp', 'archive.zip') }
    let(:url_prefix) { 'http://example.com/admin/csv/' }

    it 'performs the ZipDownload job 2 seconds later' do
      log_in_as_admin(:super_admin)

      request.env['HTTP_REFERER'] = 'http://example.com'

      expect(ZipDownloadJob).to receive(:perform_in).with(2, tmp_file_name, url_prefix)

      get :all
    end

    it 'denies access if not a super admin' do
      log_in_as_admin(:admin)

      actions = %i[
        addresses contacts holiday_schedules locations mail_addresses
        organizations phones programs regular_schedules services all download_zip
      ]
      actions.each do |action|
        expect(ZipDownloadJob).to_not receive(:perform_in)
        expect(ZipDeleteJob).to_not receive(:perform_in)

        get action

        expect(response).to redirect_to admin_dashboard_url
        expect(flash[:error]).to eq(I18n.t('admin.not_authorized'))
      end
    end
  end

  describe 'GET download_zip' do
    let(:tmp_file_name) { Rails.root.join('tmp', 'archive.zip') }
    let(:zip_file_name) { "archive-#{Time.zone.today.to_formatted_s}.zip" }

    context 'when the file exists' do
      it 'deletes the file 60 seconds later' do
        log_in_as_admin(:super_admin)

        allow(File).to receive(:exist?).with(tmp_file_name).and_return true

        expect(controller).to receive(:send_file).
          with(tmp_file_name,
               type: 'application/zip',
               filename: zip_file_name,
               x_sendfile: true)

        expect(ZipDeleteJob).to receive(:perform_in).with(60, tmp_file_name)

        get :download_zip
      end
    end

    context 'when the file does not exist' do
      it 'redirects to admin dashboard' do
        log_in_as_admin(:super_admin)

        allow(File).to receive(:exist?).with(tmp_file_name).and_return false

        get :download_zip

        expect(response).to redirect_to admin_dashboard_url
      end
    end
  end
end
