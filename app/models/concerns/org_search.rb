require 'email_filter'
require 'location_filter'

module OrgSearch
  extend ActiveSupport::Concern

  included do
    scope :category, (lambda do |category|
      joins(services: :categories).where(categories: { name: category })
      # includes(services: :categories).where(categories: { name: category })
    end)
  end

  module ClassMethods

    def find_organizations_that_have_any_of_these_categories(category_names)
      return self.all unless category_names
      query = self
      [category_names].flatten.each do |category_name|
        query = query.where(
          "organizations.id IN (?)",
          query.joins(services: :categories).where(
            'categories.name = ?', category_name
          ).pluck(:id)
        )
      end
      query.distinct
    end

    def text_search(params = {})
      return where(nil) if params.blank?
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def search_by_location_bounds(params = {})
      # includes(:locations).where(fancy bounding query)
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
