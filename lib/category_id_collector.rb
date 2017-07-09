module CategoryIdCollector
  def cat_ids(taxonomy_ids)
    return [] if taxonomy_ids.blank?
    Category.where(taxonomy_id: taxonomy_ids).pluck(:id)
  end
end
