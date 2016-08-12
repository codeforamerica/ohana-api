require 'email_filter'
require 'location_filter'

module Search
  extend ActiveSupport::Concern

  included do
    def nearbys(radius)
      r = LocationFilter.new(self.class).validated_radius(radius, 0.5)
      super(r)
    end

    scope :category, (lambda do |category|
      joins(services: :categories).where(categories: { name: category })
    end)

    scope :is_near, LocationFilter.new(self)

    scope :org_name, (lambda do |org|
      joins(:organization).where('organizations.name @@ :q', q: org)
    end)

    scope :service_area, (lambda do |sa|
      if sa == 'smc'
        joins(:services).
        where('services.service_areas && ARRAY[?]', SETTINGS[:smc_service_areas]).uniq
      else
        joins(:services).where('services.service_areas @> ARRAY[?]', sa).uniq
      end
    end)

    scope :with_email, EmailFilter.new(self)

    scope :has_market_match, (lambda do |market_match|
      if market_match.present? && market_match == '1'
        where(market_match: true)
      elsif market_match.present?
        where(market_match: false)
      end
    end)

    scope :product, ->(p) { where('products @@ :q', q: p) if p.present? }
    scope :payment, ->(p) { where('payments @@ :q', q: p) if p.present? }

    scope :has_kind, (lambda do |k|
      if k.present? && k.is_a?(Array)
        k = k.map { |v| v.parameterize.underscore }
        where('kind in (?)', k)
      elsif k.present? && k.is_a?(String)
        k = k.parameterize.underscore
        where(kind: k)
      end
    end)

    scope :sort_by_kind, (lambda do |sort, order|
      if sort.present? && order == 'desc'
        order('kind DESC')
      elsif sort.present?
        order('kind ASC')
      end
    end)
  end

  module ClassMethods
    def status(param)
      param == 'active' ? where(active: true) : where(active: false)
    end

    def keyword(query)
      where("locations.tsv_body @@ plainto_tsquery('english', ?)", query).
        order("locations.importance + #{rank_for(query)} DESC, locations.updated_at DESC")
    end

    def rank_for(query)
      sanitized = ActiveRecord::Base.sanitize(query)

      <<-RANK
        ts_rank(locations.tsv_body, plainto_tsquery('english', #{sanitized}))
      RANK
    end

    def language(lang)
      where('locations.languages && ARRAY[?]', lang)
    end

    def text_search(params = {})
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    # rubocop:disable Metrics/AbcSize
    def search(params = {})
      res = text_search(params).
            with_email(params[:email]).
            is_near(params[:location], params[:lat_lng], params[:radius]).
            has_market_match(params[:market_match]).
            has_kind(params[:kind]).
            sort_by_kind(params[:sort], params[:order])

      return res unless params[:keyword] && params[:service_area]

      res.select("locations.*, locations.importance + #{rank_for(params[:keyword])}")
    end
    # rubocop:enable Metrics/AbcSize

    def paginated_and_sorted(params)
      page(params[:page]).per(params[:per_page]).order('created_at DESC')
    end

    private

    def allowed_params(params)
      params.slice(
        :category, :keyword, :language, :org_name, :payment, :product,
        :service_area, :status
      )
    end
  end
end
