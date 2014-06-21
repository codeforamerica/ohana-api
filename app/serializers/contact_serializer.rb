class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :phone, :email, :fax

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end
end
