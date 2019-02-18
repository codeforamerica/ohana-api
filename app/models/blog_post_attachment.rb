class BlogPostAttachment < ActiveRecord::Base
  attr_accessible :file_type, :file_url, :file_legend, :order

  belongs_to :blog_post

  validates :file_url,
            presence: { message: I18n.t('errors.messages.blank_for_file_url') }
end
