class ContactSerializer < ActiveModel::Serializer
  attributes :id, :department, :email, :name, :title, :extension, :fax, :phone

  has_many :phones
end
