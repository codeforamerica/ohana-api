class ApiApplication < ActiveRecord::Base
  attr_accessible :name, :main_url, :callback_url

  belongs_to :user

  validates :name, :api_token, uniqueness: true
  validates :name, :main_url, presence: true
  validates :main_url, url: true
  validates :callback_url, url: true, allow_blank: true

  before_create :generate_api_token

  private

  def generate_api_token
    self.api_token = loop do
      random_token = SecureRandom.hex
      break random_token unless self.class.exists?(api_token: random_token)
    end
  end
end
