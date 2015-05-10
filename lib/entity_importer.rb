require 'csv'

EntityImporter = Struct.new(:content) do
  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def self.check_and_import_file(path)
    FileChecker.new(path, required_headers).validate

    process_import(path)
  end

  def self.process_import(path)
    importer = import_file(path)
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  protected

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end
end
