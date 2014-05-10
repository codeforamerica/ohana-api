class Service < ActiveRecord::Base
  belongs_to :location, touch: true

  has_and_belongs_to_many :categories, -> { uniq }
  # accepts_nested_attributes_for :categories

  # has_many :schedules
  # accepts_nested_attributes_for :schedules

  attr_accessible :audience, :description, :eligibility, :fees,
                  :funding_sources, :keywords, :how_to_apply, :name,
                  :service_areas, :short_desc, :urls, :wait

  normalize_attributes :audience, :description, :eligibility, :fees,
                       :how_to_apply, :name, :short_desc, :wait

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array
  serialize :urls, Array

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: 'Please enter a valid URL' } }

  validate :service_area_format, if: (proc do |s|
    s.service_areas.is_a?(Array) && Settings.valid_service_areas.present?
  end)

  def service_area_format
    valid_service_areas = Settings.valid_service_areas
    if service_areas.present? && (service_areas - valid_service_areas).size != 0
      errors[:base] << 'At least one service area is improperly formatted,
        or is not an accepted city or county name. Please make sure all
        words are capitalized.'
    end
  end

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :audience, unless: ->(o, _) { o.audience.blank? }
    expose :description, unless: ->(o, _) { o.description.blank? }
    expose :eligibility, unless: ->(o, _) { o.eligibility.blank? }
    expose :fees, unless: ->(o, _) { o.fees.blank? }
    expose :funding_sources, unless: ->(o, _) { o.funding_sources.blank? }
    expose :keywords, unless: ->(o, _) { o.keywords.blank? }
    expose :categories, using: Category::Entity, unless: ->(o, _) { o.categories.blank? }
    expose :how_to_apply, unless: ->(o, _) { o.how_to_apply.blank? }
    expose :name, unless: ->(o, _) { o.name.blank? }
    expose :service_areas, unless: ->(o, _) { o.service_areas.blank? }
    expose :short_desc, unless: ->(o, _) { o.short_desc.blank? }
    expose :urls, unless: ->(o, _) { o.urls.blank? }
    expose :wait, unless: ->(o, _) { o.wait.blank? }
    expose :updated_at
  end
end
