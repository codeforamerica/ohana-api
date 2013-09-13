module Kaminari
  module PageScopeMethods

    # Kaminar's built-in method for getting the previous page
    # is "prev_page", but since we are using two types of
    # collections (one that uses Kaminari, and one that uses Tire),
    # we need to be able to use the same method for both. Here, we
    # are adding a new method that Kaminari can use for Arrays.
    #
    # @return [Integer] The position of the previous within the pagination
    def previous_page
      current_page > 1 ? (current_page - 1) : nil
    end
  end
end