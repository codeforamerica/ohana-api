class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :accepted_payments, :alternate_name, :audience, :description,
             :eligibility, :email, :fees, :funding_sources, :how_to_apply,
             :keywords, :languages, :name, :required_documents, :service_areas,
             :status, :website, :wait, :updated_at

  # embed :ids, include: true
  has_many :categories
end
