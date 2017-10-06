require 'email_filter'
require 'location_filter'

module OrgSearch
  extend ActiveSupport::Concern

  included do
    scope :category, (lambda do |category|
      joins(services: :categories).where(categories: { name: category })
    end)
  end

  module ClassMethods

    def text_search(params = {})
      return where(nil) if params.blank?
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def search(params = {})
      return text_search(params)
    end

    def allowed_params(params)
      params.slice(
        :category
      )
    end
  end
end
