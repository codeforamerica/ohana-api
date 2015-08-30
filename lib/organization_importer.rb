class OrganizationImporter < EntityImporter
  def valid?
    @valid ||= organizations.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(organizations)
  end

  def import
    ActiveRecord::Base.no_touching do
      organizations.each(&:save)
    end
  end

  protected

  def organizations
    @organizations ||= csv_entries.inject([]) do |orgs, chunks|
      chunks.each do |row|
        orgs << OrganizationPresenter.new(row).to_org
      end
      orgs
    end
  end

  def self.required_headers
    %w(id accreditations alternate_name date_incorporated
       description email funding_sources legal_status
       licenses name tax_id tax_status website)
  end
end
