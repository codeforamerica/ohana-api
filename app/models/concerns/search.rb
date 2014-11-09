require 'email_filter'
require 'location_filter'

module Search
  extend ActiveSupport::Concern

  included do
    def nearbys(radius)
      r = LocationFilter.new(self.class).validated_radius(radius, 0.5)
      super(r)
    end

    scope :keyword, ->(keyword) { keyword_search(keyword) }
    scope :category, ->(category) { joins(services: :categories).where(categories: { name: category }) }

    scope :is_near, LocationFilter.new(self)

    scope :org_name, (lambda do |org|
      joins(:organization).where('organizations.name @@ :q', q: org)
    end)

    scope :with_email, EmailFilter.new(self)

    include PgSearch

    pg_search_scope :keyword_search,
                    against: :tsv_body,
                    using: {
                      tsearch: {
                        dictionary: 'english',
                        any_word: false,
                        prefix: true,
                        tsvector_column: 'tsv_body'
                      }
                    }
  end

  module ClassMethods
    def status(param)
      param == 'active' ? where(active: true) : where(active: false)
    end

    def language(lang)
      where('languages && ARRAY[?]', lang)
    end

    def service_area(sa)
      joins(:services).where('services.service_areas @@ :q', q: sa)
    end

    def text_search(params = {})
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def search(params = {})
      text_search(params).
        with_email(params[:email]).
        is_near(params[:location], params[:lat_lng], params[:radius]).
        uniq
    end

    def allowed_params(params)
      params.slice(
        :category, :keyword, :language, :org_name, :service_area, :status
      )
    end
  end
end
