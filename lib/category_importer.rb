class CategoryImporter < EntityImporter
  def valid?
    @valid ||= categories.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(categories)
  end

  def import
    ActiveRecord::Base.no_touching do
      categories.each(&:save)
    end
  end

  def self.required_headers
    %w[taxonomy_id name parent_id parent_name]
  end

  protected

  def categories
    @categories ||= csv_entries.each_with_object([]) do |chunks, result|
      chunks.each { |row| result << CategoryPresenter.new(row).to_category }
    end
  end
end
