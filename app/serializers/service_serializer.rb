class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :audience, :description, :eligibility, :fees,
             :funding_sources, :keywords, :how_to_apply, :name,
             :service_areas, :short_desc, :urls, :wait, :updated_at

  # embed :ids, include: true
  has_many :categories

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end

  def include_associations!
    include! :categories unless object.categories.blank?
  end
end
