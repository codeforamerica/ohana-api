class Admin
  class CsvController < ApplicationController
    before_action :set_filename

    # The CSV content for each action is defined in
    # app/views/admin/csv/{action_name}.csv.shaper

    def addresses
    end

    def contacts
    end

    def holiday_schedules
    end

    def locations
    end

    def mail_addresses
    end

    def organizations
    end

    def phones
    end

    def programs
    end

    def regular_schedules
    end

    def services
    end

    private

    def set_filename
      @filename = "All #{action_name} - #{Time.zone.today.to_formatted_s}.csv"
    end
  end
end
