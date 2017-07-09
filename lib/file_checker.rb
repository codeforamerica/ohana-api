class FileChecker
  def initialize(path, required_headers)
    @path = path
    @required_headers = required_headers
  end

  def validate
    return 'skip import' if missing_or_empty_but_not_required?
    if missing_or_empty?
      abort "Aborting because #{filename} is required, but is missing or empty."
    elsif invalid_headers?
      header_errors.each { |e| Kernel.puts(e) }
      abort "#{filename} was not imported. Please fix the headers and try again."
    end
  end

  def filename
    @filename ||= @path.to_s.split('/').last
  end

  def missing?
    !File.file?(@path)
  end

  def empty?
    csv_entries.all?(&:blank?)
  end

  def required_but_missing?
    required? && missing?
  end

  def required_but_empty?
    required? && empty?
  end

  def missing_or_empty?
    required_but_missing? || required_but_empty?
  end

  def missing_or_empty_but_not_required?
    !required? && (missing? || empty?)
  end

  def invalid_headers?
    missing_headers.present?
  end

  def header_errors
    missing_headers.map { |header| "CSV header #{header} is required, but is missing." }
  end

  protected

  def required?
    required_files.include? filename
  end

  def required_files
    %w[organizations.csv locations.csv addresses.csv services.csv phones.csv]
  end

  def csv_entries
    @csv_entries ||= SmarterCSV.process(@path, chunk_size: 100)
  end

  def headers
    @headers ||= CSV.open(@path, 'r', &:first).to_a
  end

  def missing_headers
    @missing_headers ||= @required_headers - headers
  end
end
