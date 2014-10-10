class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :street_1, :street_2, :city, :state, :postal_code
end
