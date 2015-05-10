class FileChecker
  def initialize(path, required_headers)
    @path = path
    @required_headers = required_headers
  end

  def validate
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

  def required_but_missing?
    required? && missing?
  end

  def required_but_empty?
    required? && csv_entries.blank?
  end

  def missing_or_empty?
    required_but_missing? || required_but_empty?
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
    %w(organizations.csv locations.csv addresses.csv services.csv phones.csv)
  end

  def content
    File.read(@path)
  end

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true).entries
  end

  def headers
    @headers ||= csv_entries.first.headers
  end

  def missing_headers
    @missing_headers ||= @required_headers - headers
  end
end
