class Category < ActiveRecord::Base
  attr_accessible :name, :oe_id

  has_and_belongs_to_many :services, -> { uniq }

  validates :name, :oe_id, presence: { message: "can't be blank for Category" }

  has_ancestry
end
