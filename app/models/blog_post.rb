class BlogPost < ActiveRecord::Base
  attr_accessible :title, :body, :posted_at, :user_id,
                  :is_published, :blog_post_attachments_attributes, :organization_id
                  :category_list

  acts_as_taggable_on :categories

  belongs_to :user
  belongs_to :organization

  has_many :blog_post_attachments, dependent: :destroy
  accepts_nested_attributes_for :blog_post_attachments,
                                allow_destroy: true, reject_if: :all_blank

  validates :title, :body,
            presence: { message: I18n.t('errors.messages.blank_for_blog_post') }

  validates :user_id, presence: true
  validates :organization_id, presence: true

  mount_uploader :images, BlogPostImageUploader
end
