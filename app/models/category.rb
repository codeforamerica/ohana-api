class Category < ActiveRecord::Base
  attr_accessible :name, :taxonomy_id

  has_and_belongs_to_many :services, -> { uniq }

  validates :name, :taxonomy_id,
            presence: { message: I18n.t('errors.messages.blank_for_category') }

  validates :taxonomy_id,
            uniqueness: {
              message: I18n.t('errors.messages.duplicate_taxonomy_id') }

  has_ancestry
end
