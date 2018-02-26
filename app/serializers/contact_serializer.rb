class ContactSerializer < ActiveModel::Serializer
  attributes :id, :department, :email, :name, :title

  has_many :phones
end
