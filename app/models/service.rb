class Service < ActiveRecord::Base
  attr_accessible :accepted_payments, :alternate_name, :audience, :description,
                  :eligibility, :email, :fees, :funding_sources, :how_to_apply,
                  :interpretation_services, :keywords, :languages, :name,
                  :required_documents, :service_areas, :status, :website,
                  :wait_time, :category_ids, :regular_schedules_attributes,
                  :holiday_schedules_attributes, :phones_attributes

  belongs_to :location, touch: true
  belongs_to :program

  has_and_belongs_to_many :categories, -> { order('taxonomy_id asc').uniq }

  has_many :regular_schedules, dependent: :destroy
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :contacts, dependent: :destroy

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :accepted_payments, :languages, :required_documents, pg_array: true

  validates :email, email: true, allow_blank: true

  validates :how_to_apply, :location,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :name, :description, :status,
            presence: { message: I18n.t('errors.messages.blank_for_service') },
            if: proc { |service| service.location && service.location.kind == 'human_services' }

  validates :service_areas, array: { service_area: true }

  validates :website, url: true, allow_blank: true

  auto_strip_attributes :alternate_name, :audience, :description, :eligibility,
                        :email, :fees, :how_to_apply, :interpretation_services,
                        :name, :wait_time, :status, :website

  auto_strip_attributes :funding_sources, :keywords, :service_areas,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :urls, Array

  extend Enumerize
  enumerize :status, in: [:active, :defunct, :inactive]

  def self.with_locations(ids)
    joins(:location).where('location_id IN (?)', ids).uniq
  end

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
