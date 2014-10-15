class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street_1, :street_2, :city, :state, :postal_code
end
