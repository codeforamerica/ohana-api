class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation,
                  :remember_me

  has_one :organization, dependent: :destroy
  has_many :blog_posts
  has_many :events

  # Devise checks for presence of email and password by default
  validates :name, presence: true
  validates :email, email: true, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :validatable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist


  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml

    super && organization_approved?
  end

  def organization_approved?
    organization.approval_status == 'approved'
  end

  def inactive_message
    organization_approved? ? super : :organization_inactive
  end
end
