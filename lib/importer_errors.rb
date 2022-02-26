ImporterErrors = Struct.new(:record, :line_number) do
  def self.messages_for(records = [])
    records.each_with_index.filter_map do |record, index|
      new(record, index + 2).message
    end
  end

  def message
    "Line #{line_number}: #{error_messages}" unless record.valid?
  end

  protected

  def error_messages
    record.errors.full_messages.uniq.join(', ')
  end
end
