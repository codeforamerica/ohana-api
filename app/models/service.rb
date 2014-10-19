class Service < ActiveRecord::Base
  attr_accessible :accepted_payments, :alternate_name, :audience, :description,
                  :eligibility, :email, :fees, :funding_sources, :how_to_apply,
                  :keywords, :languages, :name, :required_documents,
                  :service_areas, :status, :website, :wait, :category_ids

  belongs_to :location, touch: true

  has_and_belongs_to_many :categories, -> { order('oe_id asc').uniq }

  # has_many :schedules
  # accepts_nested_attributes_for :schedules

  validates :name, :description, :how_to_apply, :location,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :website, url: true, allow_blank: true

  validates :service_areas, array: { service_area: true }

  validates :accepted_payments, :languages, :required_documents, pg_array: true

  auto_strip_attributes :alternate_name, :audience, :description, :eligibility,
                        :email, :fees, :how_to_apply, :name, :wait, :status,
                        :website

  auto_strip_attributes :funding_sources, :keywords, :service_areas,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array
end
