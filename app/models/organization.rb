class Organization < ActiveRecord::Base
  include PgSearch
  multisearchable :against => :name

  attr_accessible :accreditations, :alternate_name, :date_incorporated,
                  :description, :email, :funding_sources, :legal_status,
                  :licenses, :name, :tax_id, :tax_status, :website,
                  :twitter, :facebook, :linkedin, :phones_attributes

  has_many :locations, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :services, through: :locations
  has_many :categories, through: :services
  accepts_nested_attributes_for :contacts, reject_if: :all_blank

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_org') },
            uniqueness: { case_sensitive: false }

  validates :description,
            presence: { message: I18n.t('errors.messages.blank_for_org') }

  validates :email, email: true, allow_blank: true
  validates :website, url: true, allow_blank: true

  auto_strip_attributes :alternate_name, :description, :email, :legal_status,
                        :name, :tax_id, :tax_status, :website, :twitter,
                        :facebook, :linkedin

  after_save :touch_locations, if: :needs_touch?

  def self.with_locations(ids)
    joins(:locations).where('locations.id IN (?)', ids).uniq
  end

  def self.organizations_filtered_by_categories(category_names)
    return self.all unless category_names
    query = self
    [category_names].flatten.each do |category_name|
      query = query.where(
        "organizations.id IN (?)",
        query.joins(services: :categories).where(
          'categories.name = ?', category_name
        ).pluck(:id)
      )
    end
    query.distinct
  end

  extend FriendlyId
  friendly_id :name, use: [:history]

  private

  def needs_touch?
    return false if locations.count.zero?
    name_changed?
  end

  def touch_locations
    locations.find_each(&:touch)
  end

end
