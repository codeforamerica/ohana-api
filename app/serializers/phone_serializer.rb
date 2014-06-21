class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :department, :extension, :number, :number_type, :vanity_number

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end
end
