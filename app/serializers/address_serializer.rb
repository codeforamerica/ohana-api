class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_1, :address_2, :street_1, :street_2, :city,
             :state_province, :postal_code
end
