class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :city, :state, :zip

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end
end
