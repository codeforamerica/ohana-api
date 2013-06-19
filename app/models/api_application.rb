class ApiApplication
  include Mongoid::Document

  field :name,         :type => String
  field :main_url,     :type => String
  field :callback_url, :type => String
  embedded_in :user

  validates_uniqueness_of :name
  validates_presence_of :name, :main_url, :callback_url
  validates_format_of :main_url, with: /\A(http)s?:\/\/\w/,
                                 message: "Please include the protocol"
  validates_format_of :callback_url, with: /\A(http)s?:\/\/\w/,
                                     message: "Please include the protocol"
end