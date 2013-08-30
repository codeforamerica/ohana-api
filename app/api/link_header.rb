module LinkHeader
  def set_link_header(coll)
    url   = request.url.sub(/\?.*$/, '')
    pages = {}

    # current_page and total_pages are available via the kaminari gem
    unless coll.first_page?
      pages[:first] = 1
      pages[:prev]  = coll.current_page - 1
    end

    unless coll.last_page?
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
    header "X-Total", coll.class == Tire::Results::Collection ? "#{coll.total_entries}" : "#{coll.count}"
  end

  def first_page?() current_page == 1 end
  def last_page?() current_page == total_pages end
end
