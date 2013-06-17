require 'capybara'
require 'observer'

module Scraper
  module Elements

    class List
      include Observable

      attr_reader :name, :list, :selection

      public

      def initialize(name, list)
        @name = name
        @list = list
      end

      def options
        list.all('option').map { |option| option.text }
      end

      def select(option)
        previous_value = list.value
        list.select(option)
        @selection = option
        if list.value != previous_value
          changed
          notify_observers
        end
      end
    end
  end
end