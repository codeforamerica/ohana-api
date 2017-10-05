module PaginationHeaders
  # Set Link and pagination-related HTTP headers
  #
  # @param coll ActiveRecord::Relation
  # @return various pagination-related HTTP Headers
  def generate_pagination_headers(coll)
    pages = pages(coll)

    links = links(pages, params)

    response.headers['Link'] = JSON.generate(links) if links.present?
    response.headers['X-Total-Count'] = coll.total_count.to_s
  end

  def params
    request.params.except(:controller, :format, :action, :subdomain)
  end

  def url
    request.url.sub(/\?.*$/, '')
  end

  def pages(coll)
    pages = {}
    # current_page and total_pages are available via the kaminari gem
    pages[:first] = 1
    pages[:prev]  = coll.prev_page

    pages[:last] = coll.total_pages
    pages[:next] = coll.next_page
    pages
  end

  def links(pages, params)
    _links = {}
    pages.each do |k, v|
      new_params = params.merge(page: v)
      next if new_params[:page].blank?
      _links[k] = "#{url}?#{new_params.to_param}"
    end
    _links
  end
end
