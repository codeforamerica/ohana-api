CategoryPresenter = Struct.new(:row) do
  def to_category
    return Category.create(category_params) if row[:parent_id].blank?
    return parent_category unless parent_category.valid?
    child_category
  end

  def parent_category
    @category ||= Category.find_or_create_by(name: row[:parent_name],
                                             taxonomy_id: row[:parent_id])
  end

  def child_category
    parent_category.children.create(category_params)
  end

  private

  def category_params
    raw_params = ActionController::Parameters.new(row)
    raw_params.permit(:taxonomy_id, :name)
  end
end
