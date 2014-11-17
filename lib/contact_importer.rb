class ContactImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && contacts.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(contacts)
  end

  def import
    contacts.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id organization_id service_id department email name
       title).map(&:to_sym)
  end

  protected

  def contacts
    @contacts ||= csv_entries.map(&:to_hash).map do |p|
      ContactPresenter.new(p).to_contact
    end
  end
end
