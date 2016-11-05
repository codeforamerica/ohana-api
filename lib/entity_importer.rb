require 'csv'

EntityImporter = Struct.new(:path) do
  def self.import_file(path)
    new(path).tap(&:import)
  end

  def self.check_and_import_file(path)
    check = FileChecker.new(path, required_headers).validate

    return if check == 'skip import'

    Kernel.puts("\n===> Importing #{path.to_s.split('/').last}")
    process_import(path)
  end

  def self.process_import(path)
    importer = import_file(path)
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  protected

  def csv_entries
    @csv_entries ||= SmarterCSV.process(path, chunk_size: 100)
  end
end
