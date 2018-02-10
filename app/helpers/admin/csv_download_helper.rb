class Admin
  module CsvDownloadHelper
    def csv_tables
      %w[addresses contacts holiday_schedules locations mail_addresses
         organizations phones programs regular_schedules services]
    end
  end
end
