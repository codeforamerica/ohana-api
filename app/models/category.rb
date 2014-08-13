class Category < ActiveRecord::Base
  attr_accessible :name, :oe_id

  has_and_belongs_to_many :services, -> { uniq }

  validates :name, :oe_id,
            presence: { message: I18n.t('errors.messages.blank_for_category') }

  has_ancestry
end
