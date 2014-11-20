class AddressExtractor < Struct.new(:content)
  def self.extract_addresses(path)
    content = File.read(path)
    new(content).addresses
  end

  def addresses
    @addresses ||= csv_entries.map(&:to_hash)
  end

  protected

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end
end
