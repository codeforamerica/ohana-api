class ProgramImporter < EntityImporter
  def valid?
    @valid ||= programs.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(programs)
  end

  def import
    ActiveRecord::Base.no_touching do
      programs.each(&:save)
    end
  end

  protected

  def programs
    @programs ||= csv_entries.inject([]) do |result, chunks|
      chunks.each do |row|
        result << ProgramPresenter.new(row).to_program
      end
      result
    end
  end

  def self.required_headers
    %w(id organization_id name alternate_name)
  end
end
