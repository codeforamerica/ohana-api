module LinkHeader

  # Set Link header for pagination info
  #
  # @param coll [Tire::Results::Collection or
  # @return [Sawyer::Resource]
  def set_link_header(coll)
    url   = request.url.sub(/\?.*$/, '')
    pages = {}

    # current_page and total_pages are available via the kaminari gem
    unless coll.first_page?
      pages[:first] = 1
      pages[:prev]  = coll.current_page - 1
    end

    unless coll.last_page? || coll.out_of_range?
      pages[:last] = coll.total_pages
      pages[:next] = coll.current_page + 1
    end

    links = pages.map do |k, v|
      # Grape's request.params (a Hashie::Mash) includes several params
      # that we aren't interested in for the Link header, so we remove them.
      params = request.params.except(:route_info, :method, :search_format)

      new_params = params.merge({ :page => v })
      %(<#{url}?#{new_params.to_param}>; rel="#{k}")
    end

    header 'Link', links.join(', ') unless links.empty?
    header "X-Total-Count", "#{coll.total_count}"
    header "X-Total-Pages", "#{coll.total_pages}"
    header "X-Current-Page", "#{coll.current_page}"
    header "X-Next-Page", "#{coll.next_page}" unless coll.next_page.nil?
    header "X-Previous-Page", "#{coll.previous_page}" unless coll.previous_page.nil?
  end

end
