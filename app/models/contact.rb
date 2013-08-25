class Contact
  #include RocketPants::Cacheable
  include Mongoid::Document

  #belongs_to :location
  embedded_in :location

  normalize_attributes :name, :title, :email, :fax, :phone

  field :name
  field :title
  field :email
  field :fax
  field :phone

  validates_presence_of :name, :title, :allow_blank => true

  extend ValidatesFormattingOf::ModelAdditions

  validates_formatting_of :email, with: /.+@.+\..+/i,
    allow_blank: true, message: "%{value} is not a valid email"

  validates_formatting_of :phone, :using => :us_phone,
    allow_blank: true,
    message: "%{value} is not a valid US phone number"

  validates_formatting_of :fax, :using => :us_phone,
    allow_blank: true,
    message: "%{value} is not a valid US fax number"

end
