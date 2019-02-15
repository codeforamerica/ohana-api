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
end
