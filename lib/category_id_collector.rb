module CategoryIdCollector
  def cat_ids(taxonomy_ids)
    return [] unless taxonomy_ids.present?
    Category.where(taxonomy_id: taxonomy_ids).pluck(:id)
  end
end
