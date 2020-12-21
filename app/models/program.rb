class Program < ApplicationRecord
  belongs_to :organization, optional: false
  has_many :services, dependent: :destroy

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_program') }

  auto_strip_attributes :alternate_name, :name

  def self.with_orgs(ids)
    joins(:organization).where(organization_id: ids).distinct
  end
end
