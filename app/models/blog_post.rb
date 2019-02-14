class BlogPost < ActiveRecord::Base
  attr_accessible :title, :image_legend, :body, :posted_at, :admin_id,
                  :is_published
  acts_as_taggable_on :categories

  belongs_to :admin
end
