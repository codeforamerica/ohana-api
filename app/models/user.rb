class User < ActiveRecord::Base
  attr_accessible :name, :email, :password,
                  :password_confirmation, :remember_me

  has_many :api_applications, dependent: :destroy
  accepts_nested_attributes_for :api_applications

  # Devise checks for presence of email and password by default
  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
end
