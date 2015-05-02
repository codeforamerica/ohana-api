class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :address_1, :address_2, :city, :state_province,
             :postal_code
end
