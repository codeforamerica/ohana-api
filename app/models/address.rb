class Address
  #include RocketPants::Cacheable
  include Mongoid::Document

  embedded_in :location
  #belongs_to :location
  #validates_presence_of :location

  normalize_attributes :street, :city, :state, :zip

  field :street
  field :city
  field :state
  field :zip

  validates_presence_of :street, :city, :state, :zip

  validates_length_of :state, :maximum => 2, :minimum => 2
  validates_length_of :zip, :maximum => 10, :minimum => 5

  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zip, using: :us_zip,
                            allow_blank: true,
                            message: "%{value} is not a valid ZIP code"

end