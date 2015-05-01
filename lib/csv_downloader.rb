require 'zip'
require 'open-uri'

class CsvDownloader
  TABLES = %w(locations addresses mail_addresses contacts holiday_schedules
              phones programs services regular_schedules organizations).freeze

  def initialize(file, url_prefix)
    @file = file
    @url_prefix = url_prefix
  end

  def create_zip_archive
    Zip::File.open(@file, Zip::File::CREATE) do |zipfile|
      TABLES.each do |table|
        response = open(url_for(table)).read

        zipfile.get_output_stream("#{table}.csv") { |os| os.puts(response) }
      end
    end
  end

  private

  def url_for(table)
    "#{@url_prefix}#{table}"
  end
end
