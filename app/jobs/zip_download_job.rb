require 'csv_downloader'

class ZipDownloadJob
  include SuckerPunch::Job

  def perform(tmp_file_name, url_prefix)
    ActiveRecord::Base.connection_pool.with_connection do
      CsvDownloader.new(tmp_file_name, url_prefix).create_zip_archive
    end
  end

  def later(sec, tmp_file_name, url_prefix)
    after(sec) { perform(tmp_file_name, url_prefix) }
  end
end
