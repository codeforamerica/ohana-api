class ContactImporter < EntityImporter
  def valid?
    @valid ||= contacts.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(contacts)
  end

  def import
    ActiveRecord::Base.no_touching do
      contacts.each(&:save)
    end
  end

  def self.required_headers
    %w[id location_id organization_id service_id department email name
       title]
  end

  protected

  def contacts
    @contacts ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << ContactPresenter.new(row).to_contact }
    end
  end
end
