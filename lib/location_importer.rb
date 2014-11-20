class LocationImporter < Struct.new(:content, :addresses)
  def self.import_file(path, addresses_path)
    content = File.read(path)
    addresses = AddressExtractor.extract_addresses(addresses_path)
    new(content, addresses).tap(&:import)
  end

  def valid_headers?
    missing_headers.empty?
  end

  def valid?
    @valid ||= valid_headers? && locations.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(locations)
  end

  def import
    return unless valid?
    locations.each do |location|
      location.save!
      # Slows down the geocoding. See INSTALL.md for more details.
      sleep ENV['sleep'].to_i if ENV['sleep'].present?
    end
  end

  protected

  def locations
    csv_entries.map(&:to_hash).map do |p|
      LocationPresenter.new(p, addresses).to_location
    end
  end

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
    %w(id organization_id accessibility admin_emails
       alternate_name latitude longitude description email
       languages name transportation virtual
       website).map(&:to_sym)
  end
end
