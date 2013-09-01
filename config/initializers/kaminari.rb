module Kaminari
  module PageScopeMethods

    def previous_page
      current_page > 1 ? (current_page - 1) : nil
    end
  end
end