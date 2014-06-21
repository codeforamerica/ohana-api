class MailAddressSerializer < ActiveModel::Serializer
  attributes :id, :attention, :street, :city, :state, :zip

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end
end
