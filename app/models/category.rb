class Category < ActiveRecord::Base
  include PgSearch
  multisearchable :against => :name

  attr_accessible :name, :taxonomy_id

  has_and_belongs_to_many :services

  validates :name, :taxonomy_id,
            presence: { message: I18n.t('errors.messages.blank_for_category') }

  validates :taxonomy_id,
            uniqueness: {
              message: I18n.t('errors.messages.duplicate_taxonomy_id'),
              case_sensitive: false
            }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  def slug_candidates
    [
      :name,
      [:name, :taxonomy_id]
    ]
  end

  has_ancestry
end
