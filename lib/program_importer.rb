class ProgramImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && programs.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(programs)
  end

  def import
    programs.each(&:save!) if valid?
  end

  def required_headers
    %w(id organization_id name alternate_name).map(&:to_sym)
  end

  protected

  def programs
    @programs ||= csv_entries.map(&:to_hash).map do |p|
      ProgramPresenter.new(p).to_program
    end
  end
end
