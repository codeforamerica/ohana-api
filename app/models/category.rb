class Category
  include Mongoid::Document
  acts_as_nested_set

  has_and_belongs_to_many :services
  #has_many :services

  # def name
  #   name
  # end

  def parent_name
    parent = Category.find(self.parent_id) if self.parent_id
    parent.name if parent
  end
end