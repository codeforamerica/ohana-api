class MailAddressImporter < EntityImporter
  def valid?
    @valid ||= mail_addresses.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(mail_addresses)
  end

  def import
    ActiveRecord::Base.no_touching do
      mail_addresses.each(&:save)
    end
  end

  def self.required_headers
    %w[id location_id attention address_1 address_2 city state_province postal_code
       country]
  end

  protected

  def mail_addresses
    @mail_addresses ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << MailAddressPresenter.new(row).to_mail_address }
    end
  end
end
