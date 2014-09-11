class Service < ActiveRecord::Base
  attr_accessible :audience, :description, :eligibility, :fees,
                  :funding_sources, :how_to_apply, :keywords, :name,
                  :service_areas, :short_desc, :urls, :wait, :category_ids

  belongs_to :location, touch: true

  has_and_belongs_to_many :categories, -> { order('oe_id asc').uniq }

  # has_many :schedules
  # accepts_nested_attributes_for :schedules

  validates :name, :description, :location,
            presence: { message: I18n.t('errors.messages.blank_for_service') }

  validates :urls, array: { url: true }

  validates :service_areas, array: { service_area: true }

  auto_strip_attributes :audience, :description, :eligibility, :fees,
                        :how_to_apply, :name, :short_desc, :wait

  auto_strip_attributes :funding_sources, :keywords, :service_areas, :urls,
                        reject_blank: true, nullify: false

  serialize :funding_sources, Array
  serialize :keywords, Array
  serialize :service_areas, Array
  serialize :urls, Array
end
