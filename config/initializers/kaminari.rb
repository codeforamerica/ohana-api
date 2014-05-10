module Kaminari
  # Kaminar's built-in methods for getting the next page
  # and determining if a page is the last page are wrong,
  # so I'm overriding them.
  module PageScopeMethods
    def next_page
      current_page < total_pages ? (current_page + 1) : nil
    end

    def last_page?
      current_page == total_pages
    end
  end
end
