require 'csv'

class EntityImporter < Struct.new(:content)
  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def self.check_and_import_file(path)
    file = FileChecker.new(path)

    return process_import(path) if file.available? && file.entries?

    if file.required_but_missing? || file.required_but_empty?
      fail "#{file.filename} is required but is missing or empty"
    end
  end

  def self.process_import(path)
    importer = import_file(path)
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  def valid_headers?
    missing_headers.empty?
  end

  protected

  def header_errors
    missing_headers.map { |header| "#{header} column is missing" }
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
