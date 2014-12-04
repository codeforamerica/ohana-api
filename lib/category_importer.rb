class CategoryImporter < EntityImporter

  def valid?
    @valid ||= valid_headers?
  end

  def errors
    header_errors + ImporterErrors.messages_for(categories)
  end

  def import
    return false unless valid?
    categories.each do |category|
      parent = if category['parent_name'].present?
        Category.where(name: category['parent_name'], tid: category['parent_tid']).first_or_create!
      else
        nil
      end

      opts = category.slice!('parent_name', 'parent_tid').merge(parent: parent)
      Category.create!(opts)
    end
  end

  def required_headers
    %w(id oe_id name parent_name parent_tid).map(&:to_sym)
  end

  protected

  def categories
    csv_entries.map(&:to_hash)
  end
end
