class FaxSerializer < ActiveModel::Serializer
  attributes :id, :number, :department

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end
end
