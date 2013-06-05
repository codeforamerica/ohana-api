class Organization
  include RocketPants::Cacheable
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :street_address, type: String
  field :zipcode, type: String
  field :city, type: String
  field :state, type: String
  field :urls, type: Array
  field :emails, type: Array
  field :phone, type: String
  field :faxes, type: Array
  field :ttys, type: Array
  field :service_hours, type: String
  field :phones, type: Array
  field :coordinates, type: Array
  field :latitude, type: Float
  field :longitude, type: Float
  field :business_hours, type: Hash
  field :market_match, type: Boolean
  field :schedule, type: String
  field :payments_accepted, type: Array
  field :products_sold, type: Array
  field :languages_spoken, type: Array
  field :keywords, type: Array 
  field :target_group, type: String
  field :eligibility_requirements, type: String
  field :fees, type: String
  field :how_to_apply, type: String
  field :service_wait, type: String
  field :transportation_availability, type: String
  field :accessibility, type: String
  field :services_provided, type: String
  field :service_area, type: Array
  field :funding_sources, type: Array
  field :contact_person, type: Array

  validates_presence_of :name
  
  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip, allow_blank: true, message: "Please enter a valid ZIP code"
  validates_formatting_of :phone, using: :us_phone, allow_blank: true, message: "Please enter a valid US phone number"
  validates :emails, array: { format: { with: /.+@.+\..+/i, message: "Please enter a valid email" } }
  validates :urls,   array: { format: 
                            { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i, 
                              message: "Please enter a valid URL" } }
  
  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates

  scope :find_by_keyword,  lambda { |keyword| any_of({name: /\b#{keyword}\b/i}, {keywords: /\b#{keyword}\b/i}) } 
  scope :find_by_location, lambda {|location, radius| near(location, radius) }

  #combines address fields together into one string
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def market_match?
    self.market_match
  end
end
