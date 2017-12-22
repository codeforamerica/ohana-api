class Program < ActiveRecord::Base
  belongs_to :organization
  has_many :services, dependent: :destroy

  validates :name, :organization,
            presence: { message: I18n.t('errors.messages.blank_for_program') }

  auto_strip_attributes :alternate_name, :name

  def self.with_orgs(ids)
    joins(:organization).where('organization_id IN (?)', ids).uniq
  end
end
