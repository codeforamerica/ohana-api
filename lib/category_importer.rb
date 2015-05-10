class CategoryImporter < EntityImporter
  def valid?
    @valid ||= categories.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(categories)
  end

  def import
    categories.each(&:save!) if valid?
  end

  protected

  def categories
    @categories ||= csv_entries.map(&:to_hash).map do |p|
      CategoryPresenter.new(p).to_category
    end
  end

  def self.required_headers
    %w(taxonomy_id name parent_id parent_name)
  end
end
