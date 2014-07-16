class Service < ActiveRecord::Base
  attr_accessible :audience, :description, :eligibility, :fees,
                  :funding_sources, :how_to_apply, :keywords, :name,
                  :service_areas, :short_desc, :urls, :wait, :category_ids,
                  :location_id

  belongs_to :location, touch: true

  has_and_belongs_to_many :categories, -> { order('oe_id asc').uniq }

  # has_many :schedules
  # accepts_nested_attributes_for :schedules

  validates :name, :description, :location,
            presence: { message: "can't be blank for Service" }

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: '%{value} is not a valid URL' } }

  validate :service_area_format, if: (proc do |s|
    s.service_areas.is_a?(Array) && SETTINGS[:valid_service_areas].present?
  end)

  auto_strip_attributes :audience, :description, :eligibility, :fees,
                        :how_to_apply, :name, :short_desc, :wait

  auto_strip_attributes :funding_sources, :keywords, :service_areas, :urls,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array
  serialize :urls, Array

  def service_area_format
    return unless service_areas.present?
    valid_service_areas = SETTINGS[:valid_service_areas]
    return unless (service_areas - valid_service_areas).size != 0
    error_message = 'At least one service area is improperly formatted, ' \
      'or is not an accepted city or county name. Please make sure all ' \
      'words are capitalized.'
    errors.add(:service_areas, error_message)
  end
end
