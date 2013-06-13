class Organization
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  field :accessibility_options, type: Array
  field :agency, type: String
  field :ask_for, type: Array
  field :city, type: String
  field :coordinates, type: Array
  field :description, type: String
  field :eligibility_requirements, type: String
  field :emails, type: Array
  field :faxes, type: Array
  field :fees, type: String
  field :funding_sources, type: Array
  field :how_to_apply, type: String
  field :keywords, type: Array 
  field :languages_spoken, type: Array
  field :latitude, type: Float
  field :leaders, type: Array
  field :longitude, type: Float
  field :market_match, type: Boolean
  field :name, type: String
  field :payments_accepted, type: Array
  field :phones, type: Array
  field :products_sold, type: Array
  field :service_areas, type: Array
  field :service_hours, type: String
  field :service_wait, type: String
  field :services_provided, type: String
  field :state, type: String
  field :street_address, type: String
  field :target_group, type: String
  field :transportation_availability, type: String
  field :ttys, type: Array 
  field :urls, type: Array
  field :zipcode, type: String
  
  validates_presence_of :name
  
  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip, allow_blank: true, message: "Please enter a valid ZIP code"
  validates :phones, hash:  { format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/, allow_blank: true, message: "Please enter a valid US phone number"} }
  validates :emails, array: { format: { with: /.+@.+\..+/i, message: "Please enter a valid email" } }
  validates :urls,   array: { format: 
                            { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i, 
                              message: "Please enter a valid URL"} }
  
  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates

  scope :find_by_keyword,  lambda { |keyword| any_of({name: /\b#{keyword}\b/i}, {keywords: /\b#{keyword}\b/i}, {agency: /\b#{keyword}\b/i}) } 
  scope :find_by_location, lambda {|location, radius| near(location, radius) }

  #combines address fields together into one string
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def market_match?
    self.market_match
  end
end
