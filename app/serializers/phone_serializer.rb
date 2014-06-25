class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :department, :extension, :number, :number_type, :vanity_number
end
