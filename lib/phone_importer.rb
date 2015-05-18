class PhoneImporter < EntityImporter
  def valid?
    @valid ||= phones.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(phones)
  end

  def import
    phones.each(&:save)
  end

  protected

  def phones
    @phones ||= csv_entries.map(&:to_hash).map do |p|
      PhonePresenter.new(p).to_phone
    end
  end

  def self.required_headers
    %w(id location_id organization_id service_id contact_id department
       extension number number_type vanity_number country_prefix)
  end
end
