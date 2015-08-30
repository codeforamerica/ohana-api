AddressExtractor = Struct.new(:path) do
  def self.extract_addresses(path)
    new(path).csv_entries
  end

  def csv_entries
    @csv_entries ||= SmarterCSV.process(path, convert_values_to_numeric: false)
  end
end
