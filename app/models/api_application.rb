class ApiApplication < ActiveRecord::Base

  before_create :generate_api_token

  belongs_to :user

  attr_accessible :name, :main_url, :callback_url

  validates_uniqueness_of :name, :api_token
  validates_presence_of :name, :main_url, :callback_url
  validates_format_of :main_url, with: /\A(http)s?:\/\/\w/,
                                 message: "Please include the protocol"
  validates_format_of :callback_url, with: /\A(http)s?:\/\/\w/,
                                     message: "Please include the protocol"

  private
  def generate_api_token
    self.api_token = loop do
      random_token = SecureRandom.hex
      break random_token unless self.class.exists?(api_token: random_token)
    end
  end
end