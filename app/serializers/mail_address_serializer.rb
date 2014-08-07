class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :street, :city, :state, :zip
end
