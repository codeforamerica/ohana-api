module LinkHeader
  # Set Link and pagination-related HTTP headers
  #
  # @param coll ActiveRecord::Relation
  # @return various pagination-related HTTP Headers
  def generate_pagination_headers(coll)
    params = request.params.except(:route_info, :method, :search_format)

    pages = pages(coll)

    links = links(pages, params)

    links.delete_if { |v| v.blank? }

    header 'Link', links.join(', ') unless links.blank?
    header 'X-Total-Count', "#{coll.total_count}"
    header 'X-Total-Pages', "#{coll.total_pages}"
    header 'X-Current-Page', "#{coll.current_page}" unless coll.empty?
    header 'X-Next-Page', "#{coll.next_page}" unless coll.next_page.nil?
    header 'X-Previous-Page', "#{pages[:prev]}" unless coll.prev_page.nil?
  end

  def url
    request.url.sub(/\?.*$/, '')
  end

  def pages(coll)
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
    pages
  end

  def links(pages, params)
    pages.map do |k, v|
      new_params = params.merge(page: v)
      unless new_params[:page].blank?
        %(<#{url}?#{new_params.to_param}>; rel="#{k}")
      end
    end
  end
end
