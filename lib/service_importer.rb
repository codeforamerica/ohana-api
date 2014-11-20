class ServiceImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && services.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(services)
  end

  def import
    services.each(&:save!) if valid?
  end

  def required_headers
    %w(id location_id program_id accepted_payments alternate_name description
       eligibility email fees funding_sources how_to_apply languages name
       required_documents service_areas status website wait_time).map(&:to_sym)
  end

  protected

  def services
    @services ||= csv_entries.map(&:to_hash).map do |p|
      ServicePresenter.new(p).to_service
    end
  end
end
