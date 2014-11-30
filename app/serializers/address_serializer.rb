class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :street_1, :street_2, :city, :state, :state_province,
             :postal_code, :zip
end
