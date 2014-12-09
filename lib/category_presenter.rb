class CategoryPresenter < Struct.new(:row)
  def to_category
    return parent_category(row).children.create(row) if row[:parent_id].present?
    Category.create(row)
  end

  def parent_category(row)
    Category.find_or_create_by(name: row[:parent_name],
                               taxonomy_id: row[:parent_id])
  end
end
