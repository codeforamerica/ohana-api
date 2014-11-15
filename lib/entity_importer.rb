require 'csv'

class EntityImporter < Struct.new(:content)
  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def valid_headers?
    missing_headers.empty?
  end

  protected

  def header_errors
    missing_headers.map { |header| "#{header.to_s.humanize} column is missing" }
  end

  def missing_headers
    required_headers - headers
  end

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end

  def headers
    @headers ||= csv_entries.first.headers
  end

  def required_headers
  end
end
