class Service < ApplicationRecord
  belongs_to :location, touch: true, optional: false
  belongs_to :program, optional: true

  has_and_belongs_to_many :categories,
                          after_add: :touch_location,
                          after_remove: :touch_location

  has_many :regular_schedules, dependent: :destroy, inverse_of: :service
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy, inverse_of: :service
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :contacts, dependent: :destroy, inverse_of: :service

  has_many :phones, dependent: :destroy, inverse_of: :service
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :accepted_payments, :languages, :required_documents, pg_array: true

  validates :email, email: true, allow_blank: true

  validates :name, :description, :status,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :service_areas, array: { service_area: true }

  validates :website, url: true, allow_blank: true

  auto_strip_attributes :alternate_name, :audience, :description, :eligibility,
                        :email, :fees, :application_process, :interpretation_services,
                        :name, :wait_time, :status, :website

  auto_strip_attributes :funding_sources, :keywords, :service_areas,
                        reject_blank: true, nullify: true, nullify_array: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array

  extend Enumerize
  enumerize :status, in: %i[active defunct inactive]

  def self.with_locations(ids)
    joins(:location).where(location_id: ids).distinct
  end

  after_validation :remove_duplicates
  after_save :update_location_status, if: :saved_change_to_status?

  private

  # rubocop:disable Rails/SkipsModelValidations
  def update_location_status
    return if location.active == location_services_active?

    location.update_columns(active: location_services_active?)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def location_services_active?
    location.services.pluck(:status).include?('active')
  end

  # rubocop:disable Rails/SkipsModelValidations
  def touch_location(_category)
    location.update_column(:updated_at, Time.zone.now) if persisted?
  end
  # rubocop:enable Rails/SkipsModelValidations

  def remove_duplicates
    [service_areas, keywords, funding_sources].each(&:uniq!)
  end
end
