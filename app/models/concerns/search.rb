module Search
  extend ActiveSupport::Concern

  included do
    scope :language, ->(language) { where('languages @@ :q', q: language) }
    scope :keyword, ->(keyword) { keyword_search(keyword) }
    scope :category, ->(category) { joins(services: :categories).where(categories: { name: category }) }

    scope :is_near, (lambda do |loc, lat_lng, r|
      if loc.present?
        result = Geocoder.search(loc, bounds: SETTINGS[:bounds])
        coords = result.first.coordinates if result.present?
        near(coords, validated_radius(r, 5))
      elsif lat_lng.present?
        coords = validated_coordinates(lat_lng)
        near(coords, validated_radius(r, 5))
      end
    end)

    scope :org_name, (lambda do |org|
      joins(:organization).where('organizations.name @@ :q', q: org)
    end)

    scope :service_area, (lambda do |sa|
      if sa == 'smc'
        joins(:services).
          where('services.service_areas && ARRAY[?]', SETTINGS[:smc_service_areas])
      else
        joins(:services).where('services.service_areas @> ARRAY[?]', sa)
      end
    end)

    scope :email, (lambda do |email|
      return Location.none unless email.include?('@')

      domain = email.split('@').last

      locations = Location.arel_table

      if SETTINGS[:generic_domains].include?(domain)
        # where('admin_emails @@ :q or emails @@ :q', q: email)
        Location.where(locations[:admin_emails].matches("%#{email}%").
                or(locations[:emails].matches("%#{email}%")))
      else
        # where('urls ilike :q or emails ilike :q or admin_emails @@ :p', q: "%#{domain}%", p: email)
        Location.where(locations[:admin_emails].matches("%#{email}%").
                or(locations[:urls].matches("%#{domain}%")).
                or(locations[:emails].matches("%#{domain}%")))
      end
    end)

    scope :has_market_match, (lambda do |market_match|
      if market_match.present? && market_match == '1'
        where(market_match: true)
      elsif market_match.present?
        where(market_match: false)
      end
    end)

    scope :has_products, ->(p) { where('products @@ :q', q: p) if p.present? }
    scope :has_payments, ->(p) { where('payments @@ :q', q: p) if p.present? }

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
                    },
                    ranked_by: 'importance + :tsearch'
  end

  module ClassMethods
    require 'exceptions'

    def text_search(params = {})
      allowed_params(params).reduce(self) do |relation, (scope_name, value)|
        value.present? ? relation.public_send(scope_name, value) : relation.all
      end
    end

    def search(params = {})
      text_search(params).
        is_near(params[:location], params[:lat_lng], params[:radius]).
        has_market_match(params[:market_match]).
        has_payments(params[:payments]).
        has_products(params[:products]).
        has_kind(params[:kind]).
        sort_by_kind(params[:sort], params[:order]).
        uniq
    end

    def validated_radius(radius, custom_radius)
      return custom_radius unless radius.present?
      if radius.to_f == 0.0
        fail Exceptions::InvalidRadius
      else
        # radius must be between 0.1 miles and 50 miles
        [[0.1, radius.to_f].max, 50].min
      end
    end

    def validated_coordinates(lat_lng)
      lat, lng = lat_lng.split(',')
      fail Exceptions::InvalidLatLon if lat.to_f == 0.0 || lng.to_f == 0.0
      [Float(lat), Float(lng)]
    end

    def allowed_params(params)
      params.slice(:category, :email, :keyword, :language, :org_name,
                   :service_area)
    end

    def cache_key
      Digest::MD5.hexdigest "#{maximum(:updated_at).try(:to_i)}-#{count(:all)}"
    end
  end
end
