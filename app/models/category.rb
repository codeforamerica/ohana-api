class Category < ActiveRecord::Base
  attr_accessible :name, :oe_id, :tid

  has_and_belongs_to_many :services, -> { uniq }

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_category') }

  has_ancestry


end
