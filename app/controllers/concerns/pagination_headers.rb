module PaginationHeaders
  # Set Link and pagination-related HTTP headers
  #
  # @param coll ActiveRecord::Relation
  # @return various pagination-related HTTP Headers
  def generate_pagination_headers(coll)
    pages = pages(coll)

    links = links(pages)

    links.delete_if(&:blank?)

    response.headers['Link'] = links.join(', ') if links.present?
    response.headers['X-Total-Count'] = coll.total_count.to_s
  end

  def filtered_params
    params.permit(
      { category: [] }, :category, :keyword, :language, :org_name, :service_area, :status, :per_page
    )
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

  def links(pages)
    pages.map do |k, v|
      new_params = filtered_params.merge(page: v)
      next if new_params[:page].blank?
      %(<#{url}?#{new_params.to_param}>; rel="#{k}")
    end
  end
end
