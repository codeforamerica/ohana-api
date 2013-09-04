class Category
  include Mongoid::Document
  acts_as_nested_set

  has_and_belongs_to_many :services
  #has_many :services
end