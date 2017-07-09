class ServiceImporter < EntityImporter
  def valid?
    @valid ||= services.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(services)
  end

  def import
    ActiveRecord::Base.no_touching do
      services.each(&:save)
    end
  end

  def self.required_headers
    %w[id location_id program_id accepted_payments alternate_name description
       eligibility email fees funding_sources application_process languages name
       required_documents service_areas status website wait_time]
  end

  protected

  def services
    @services ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << ServicePresenter.new(row).to_service }
    end
  end
end
