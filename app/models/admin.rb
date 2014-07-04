class Admin < ActiveRecord::Base
  attr_accessible :name, :email, :password,
                  :password_confirmation, :remember_me

  # Devise already checks for presence of email and password.
  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  def org
    domain = email.split('@').last
    admin_locs = Location.text_search(domain: domain)
    admin_locs.includes(:organization).first.organization if admin_locs.present?
  end
end
