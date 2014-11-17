class PhoneImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && phones.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(phones)
  end

  def import
    phones.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id organization_id service_id contact_id department
       extension number number_type vanity_number country_prefix).map(&:to_sym)
  end

  protected

  def phones
    @phones ||= csv_entries.map(&:to_hash).map do |p|
      PhonePresenter.new(p).to_phone
    end
  end
end
