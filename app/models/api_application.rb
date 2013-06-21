class ApiApplication
  include Mongoid::Document

  before_create :generate_access_token

  # Mongoid field types are String be default,
  # so we can omit the type declaration
  field :name
  field :main_url
  field :callback_url
  field :access_token
  embedded_in :user

  attr_accessible :name, :main_url, :callback_url

  validates_uniqueness_of :name, :access_token
  validates_presence_of :name, :main_url, :callback_url
  validates_format_of :main_url, with: /\A(http)s?:\/\/\w/,
                                 message: "Please include the protocol"
  validates_format_of :callback_url, with: /\A(http)s?:\/\/\w/,
                                     message: "Please include the protocol"

  private
  def generate_access_token
    self.access_token = loop do
      random_token = SecureRandom.hex
      break random_token unless User.where('api_applications.access_token' => random_token).exists?
    end
  end
end