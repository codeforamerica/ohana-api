class User < ApplicationRecord
  has_many :api_applications, dependent: :destroy
  accepts_nested_attributes_for :api_applications

  # Devise checks for presence of email and password by default
  validates :name, presence: true
  validates :email, email: true, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable
end
