class NearbySerializer < ActiveModel::Serializer
  attributes :id, :alternate_name, :latitude, :longitude, :name, :slug

  has_one :address
end
