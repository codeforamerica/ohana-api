class Contact
  #include RocketPants::Cacheable
  include Mongoid::Document
  include Grape::Entity::DSL

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

  entity do
    expose    :id
    expose  :name, :unless => lambda { |o,_| o.name.blank? }
    expose :title, :unless => lambda { |o,_| o.title.blank? }
    expose :phone, :unless => lambda { |o,_| o.phone.blank? }
    expose :email, :unless => lambda { |o,_| o.email.blank? }
    expose   :fax, :unless => lambda { |o,_| o.fax.blank? }
  end

end
