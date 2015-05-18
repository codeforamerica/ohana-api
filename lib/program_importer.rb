class ProgramImporter < EntityImporter
  def valid?
    @valid ||= programs.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(programs)
  end

  def import
    programs.each(&:save)
  end

  protected

  def programs
    @programs ||= csv_entries.map(&:to_hash).map do |p|
      ProgramPresenter.new(p).to_program
    end
  end

  def self.required_headers
    %w(id organization_id name alternate_name)
  end
end
