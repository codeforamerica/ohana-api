class Category < ActiveRecord::Base
  include PgSearch

  attr_accessible :name, :taxonomy_id

  has_and_belongs_to_many :services

  validates :name, :taxonomy_id,
            presence: { message: I18n.t('errors.messages.blank_for_category') }

  validates :taxonomy_id,
            uniqueness: {
              message: I18n.t('errors.messages.duplicate_taxonomy_id'),
              case_sensitive: false
            }
  pg_search_scope :search_by_name,
                  :against => :name,
                  :using => {
                    :tsearch => {:any_word => true},
                    :dmetaphone => {:any_word => true},
                    :trigram => {:threshold => 0.1}
                  }
  has_ancestry
end
