LocationImporter = Struct.new(:content, :addresses) do
  def self.import_file(path, addresses_path)
    content = File.read(path)
    new(content, addresses_for(addresses_path)).tap(&:import)
  end

  def self.check_and_import_file(locations_path, addresses_path)
    FileChecker.new(locations_path, required_headers).validate

    process_import(locations_path, addresses_path)
  end

  def self.process_import(locations_path, addresses_path)
    importer = import_file(locations_path, addresses_path)
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  def self.addresses_for(addresses_path)
    FileChecker.new(addresses_path, required_address_headers).validate

    AddressExtractor.extract_addresses(addresses_path)
  end

  def valid?
    @valid ||= locations.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(locations)
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

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end

  def self.required_headers
    %w(id organization_id accessibility admin_emails
       alternate_name latitude longitude description email
       languages name transportation virtual
       website)
  end

  def self.required_address_headers
    %w(id location_id address_1 address_2 city state_province postal_code
       country)
  end
end
