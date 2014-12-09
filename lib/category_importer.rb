class CategoryImporter < EntityImporter
  def valid?
    @valid ||= valid_headers? && categories.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(categories)
  end

  def import
    categories.each(&:save!) if valid?
  end

  def required_headers
    %w(taxonomy_id name parent_id parent_name).map(&:to_sym)
  end

  protected

  def categories
    @categories ||= csv_entries.map(&:to_hash).map do |p|
      CategoryPresenter.new(p).to_category
    end
  end
end
