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


  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml

    super && organization_approved? && !deleted_at
  end

  def organization_approved?
    organization.approval_status == 'approved'
  end

  def inactive_message
    if !deleted_at && organization_approved?
      super
    elsif !organization_approved?
      :organization_inactive
    elsif deleted_at
      :deleted_account
    end
  end
end
