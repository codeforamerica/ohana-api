class Category
  include Mongoid::Document
  acts_as_nested_set

  has_and_belongs_to_many :locations
  #has_many :locations
end