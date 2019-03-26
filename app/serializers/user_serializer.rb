class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :organization_id

  def organization_id
    object.try(:organization).try(:id)
  end
end
