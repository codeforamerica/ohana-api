class ServiceImporter < EntityImporter
  def valid?
    @valid ||= services.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(services)
  end

  def import
    services.each(&:save!) if valid?
  end

  protected

  def services
    @services ||= csv_entries.map(&:to_hash).map do |p|
      ServicePresenter.new(p).to_service
    end
  end

  def self.required_headers
    %w(id location_id program_id accepted_payments alternate_name description
       eligibility email fees funding_sources application_process languages name
       required_documents service_areas status website wait_time)
  end
end
