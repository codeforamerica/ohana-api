class Service
  #include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  # embedded_in :location
  belongs_to :location
  validates_presence_of :location

  has_and_belongs_to_many :categories
  #belongs_to :category

  embeds_many :schedules
  accepts_nested_attributes_for :schedules
  #accepts_nested_attributes_for :categories

  normalize_attributes :audience, :description, :eligibility, :fees,
    :how_to_apply, :name, :short_desc, :wait

  field :audience
  field :description
  field :eligibility
  field :fees
  field :funding_sources, type: Array
  field :keywords, type: Array
  field :how_to_apply
  field :name
  field :service_areas, type: Array
  field :short_desc
  field :urls, type: Array
  field :wait

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "Please enter a valid URL" } }

  entity do
    expose              :id
    expose        :audience, :unless => lambda { |o,_| o.audience.blank? }
    expose     :description, :unless => lambda { |o,_| o.description.blank? }
    expose     :eligibility, :unless => lambda { |o,_| o.eligibility.blank? }
    expose            :fees, :unless => lambda { |o,_| o.fees.blank? }
    expose :funding_sources, :unless => lambda { |o,_| o.funding_sources.blank? }
    expose        :keywords, :unless => lambda { |o,_| o.keywords.blank? }
    #expose      :categories, :using => Category::Entity, :unless => lambda { |o,_| o.categories.blank? }
    expose      :categories, :unless => lambda { |o,_| o.categories.blank? }
    expose    :how_to_apply, :unless => lambda { |o,_| o.how_to_apply.blank? }
    expose            :name, :unless => lambda { |o,_| o.name.blank? }
    expose   :service_areas, :unless => lambda { |o,_| o.service_areas.blank? }
    expose      :short_desc, :unless => lambda { |o,_| o.short_desc.blank? }
    expose            :urls, :unless => lambda { |o,_| o.urls.blank? }
    expose            :wait, :unless => lambda { |o,_| o.wait.blank? }
    expose      :updated_at
  end
end