require 'roar/representer/json'

module ContactRepresenter
  include Roar::Representer::JSON

  property :name
  property :title
  property :phone
  property :email
  property :fax

end
