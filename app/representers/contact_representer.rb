require 'roar/representer/json'

module ContactRepresenter
  include Roar::Representer::JSON

  property :name
  property :title
  property :email
  property :fax
  property :phone

end
