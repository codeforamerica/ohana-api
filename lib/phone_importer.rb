class PhoneImporter < EntityImporter
  def valid?
    @valid ||= phones.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(phones)
  end

  def import
    ActiveRecord::Base.no_touching do
      phones.each(&:save)
    end
  end

  protected

  def phones
    @phones ||= csv_entries.inject([]) do |result, chunks|
      chunks.each do |row|
        result << PhonePresenter.new(row).to_phone
      end
      result
    end
  end

  def self.required_headers
    %w(id location_id organization_id service_id contact_id department
       extension number number_type vanity_number country_prefix)
  end
end
