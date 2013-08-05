class Category
  include Mongoid::Document
  acts_as_nested_set

  has_many :locations
end