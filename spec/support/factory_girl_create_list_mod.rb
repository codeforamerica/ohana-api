require 'factory_girl_rails'

module FactoryGirl
  module Syntax
    # Override Factory Girl's 'create_list' method so that it warns
    # you if you try to create more than 2 records in the DB.
    # Specs should be as light as possible.
    # Read more here:
    # http://robots.thoughtbot.com/taming-factory-girl-list-creation
    module Methods
      alias_method :original_create_list, :create_list

      def create_list(name, amount, *traits_and_overrides, &block)
        if amount > 2
          fail ArgumentError,
               "You asked to create #{amount} records. Don't do that."
        end

        original_create_list(name, amount, *traits_and_overrides, &block)
      end
    end
  end
end
