class ContactSerializer < ActiveModel::Serializer
  attributes :department, :email, :id, :name, :title

  has_many :phones
end
