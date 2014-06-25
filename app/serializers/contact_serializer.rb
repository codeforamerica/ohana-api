class ContactSerializer < ActiveModel::Serializer
  attributes :email, :extension, :fax, :id, :name, :phone, :title
end
