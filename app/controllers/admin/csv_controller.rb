class Admin
  class CsvController < ApplicationController
    # The CSV content for each action is defined in
    # app/views/admin/csv/{action_name}.csv.shaper

    def addresses; end

    def contacts; end

    def holiday_schedules; end

    def locations; end

    def mail_addresses; end

    def organizations; end

    def phones; end

    def programs; end

    def regular_schedules; end

    def services; end

    def all
      redirect_to :back,
                  notice: I18n.t('admin.notices.zip_file_generation')
      ZipDownloadJob.perform_in(2, tmp_file_name, url_prefix)
    end

    def download_zip
      if File.exist?(tmp_file_name)
        send_file tmp_file_name,
                  type: 'application/zip',
                  filename: zip_file_name,
                  x_sendfile: true

        ZipDeleteJob.perform_in(60, tmp_file_name)
      else
        redirect_to admin_dashboard_url,
                    notice: I18n.t('admin.notices.wait_for_zip_file')
      end
    end

    private

    def tmp_file_name
      @tmp_file_name ||= "#{Rails.root}/tmp/archive.zip"
    end

    def zip_file_name
      "archive-#{Time.zone.today.to_formatted_s}.zip"
    end

    def url_prefix
      @url_prefix ||= "#{admin_dashboard_url(subdomain: ENV['ADMIN_SUBDOMAIN'])}/csv/"
    end
  end
end
