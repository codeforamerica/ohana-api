class Service < ActiveRecord::Base
  attr_accessible :accepted_payments, :alternate_name, :audience, :description,
                  :eligibility, :email, :fees, :funding_sources, :how_to_apply,
                  :keywords, :languages, :name, :required_documents,
                  :service_areas, :status, :website, :wait, :category_ids

  belongs_to :location, touch: true
  belongs_to :program

  has_and_belongs_to_many :categories, -> { order('oe_id asc').uniq }

  # has_many :schedules
  # accepts_nested_attributes_for :schedules

  validates :accepted_payments, :languages, :required_documents, pg_array: true

  validates :email, email: true, allow_blank: true

  validates :name, :description, :how_to_apply, :location, :status,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :service_areas, array: { service_area: true }

  validates :website, url: true, allow_blank: true

  auto_strip_attributes :alternate_name, :audience, :description, :eligibility,
                        :email, :fees, :how_to_apply, :name, :wait, :status,
                        :website

  auto_strip_attributes :funding_sources, :keywords, :service_areas,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array

  extend Enumerize
  enumerize :status, in: [:active, :defunct, :inactive]

  after_save :update_location_status, if: :status_changed?

  private

  def update_location_status
    return if location.active == location_services_active?
    location.update_columns(active: location_services_active?)
  end

  def location_services_active?
    location.services.pluck(:status).include?('active')
  end
end
