class Admin
  module ZipDownloadHelper
    def zip_file_status
      if File.exist?(tmp_file_name)
        link_to(
          I18n.t('admin.buttons.download_zip_file'),
          admin_csv_download_zip_url, class: 'btn btn-primary'
        )
      else
        link_to(
          I18n.t('admin.buttons.generate_zip_file'), admin_csv_all_path, class: 'btn btn-primary'
        )
      end
    end

    def tmp_file_name
      "#{Rails.root}/tmp/archive.zip"
    end
  end
end
