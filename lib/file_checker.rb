require 'csv'

class FileChecker
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def filename
    path.to_s.split('/').last
  end

  def available?
    File.file?(path)
  end

  def missing?
    !available?
  end

  def entries?
    csv_entries.present?
  end

  def required_but_missing?
    required? && !available?
  end

  def required_but_empty?
    required? && !entries?
  end

  protected

  def required?
    required_files.include? filename
  end

  def content
    File.read(path)
  end

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true).entries
  end

  def required_files
    %w(organizations.csv locations.csv addresses.csv services.csv phones.csv
       regular_schedules.csv holiday_schedules.csv)
  end
end
