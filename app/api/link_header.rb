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
      pages[:prev]  = coll.empty? ? coll.total_pages : coll.current_page - 1
    end

    unless coll.last_page?
      pages[:last] = coll.total_pages
      pages[:next] = coll.empty? ? nil : coll.current_page + 1
    end

    # Grape's request.params (a Hashie::Mash) includes several params
    # that we aren't interested in for the Link header, so we remove them.
    params = request.params.except(:route_info, :method, :search_format)

    links = pages.map do |k, v|
      new_params = params.merge({ :page => v })
      unless new_params[:page].blank?
        %(<#{url}?#{new_params.to_param}>; rel="#{k}")
      end
    end

    links.delete_if { |v| v.blank? }

    header 'Link', links.join(', ') unless links.blank?
    header "X-Total-Count", "#{coll.total_count}"
    header "X-Total-Pages", "#{coll.total_pages}"
    header "X-Current-Page", "#{coll.current_page}" unless coll.empty?
    header "X-Next-Page", "#{coll.next_page}" unless coll.next_page.nil?
    header "X-Previous-Page", "#{pages[:prev]}" unless coll.previous_page.nil?
  end

end
