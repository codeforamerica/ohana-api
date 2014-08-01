class Fax < ActiveRecord::Base
  default_scope { order('id ASC') }

  attr_accessible :number, :department

  belongs_to :location, touch: true

  validates :number,
            presence: { message: I18n.t('errors.messages.blank_for_fax') },
            fax: true

  auto_strip_attributes :number, :department, squish: true

  include TrackChanges
end
