class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :accepted_payments, :alternate_name, :application_process,
             :audience, :description, :eligibility, :email, :fees,
             :funding_sources, :interpretation_services, :keywords, :languages,
             :name, :required_documents, :service_areas, :status, :website,
             :wait_time, :updated_at

  # embed :ids, include: true
  has_many :categories
  has_many :contacts
  has_many :phones
  has_many :regular_schedules
  has_many :holiday_schedules
end
