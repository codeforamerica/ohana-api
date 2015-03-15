class MailAddressImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && mail_addresses.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(mail_addresses)
  end

  def import
    mail_addresses.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id attention address_1 address_2 city state_province postal_code
       country).map(&:to_sym)
  end

  protected

  def mail_addresses
    @mail_addresses ||= csv_entries.map(&:to_hash).map do |p|
      MailAddressPresenter.new(p).to_mail_address
    end
  end
end
