class OrganizationImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && organizations.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(organizations)
  end

  def import
    organizations.each(&:save!) if valid?
  end

  def required_headers
    %w(id accreditations alternate_name date_incorporated
       description email funding_sources legal_status
       licenses name tax_id tax_status website).map(&:to_sym)
  end

  protected

  def organizations
    csv_entries.map(&:to_hash).map do |p|
      OrganizationPresenter.new(p).to_org
    end
  end
end
