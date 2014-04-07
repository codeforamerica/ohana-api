class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Devise checks for presence of email and password by default
  validates_presence_of :name

  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :name, :email, :password,
                  :password_confirmation, :remember_me

  has_many :api_applications, :dependent => :destroy
  accepts_nested_attributes_for :api_applications
end
