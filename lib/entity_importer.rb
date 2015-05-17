require 'csv'

EntityImporter = Struct.new(:content) do
  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def self.check_and_import_file(path)
    check = FileChecker.new(path, required_headers).validate

    if check != 'skip import'
      Kernel.puts("\n===> Importing #{path.to_s.split('/').last}")
      process_import(path)
    end
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
