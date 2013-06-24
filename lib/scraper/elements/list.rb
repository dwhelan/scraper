require 'capybara'
require 'observer'

module Scraper
  module Elements

    class List
      include Observable

      attr_reader :name, :list, :selection
      attr_accessor :max_options

      public

      def initialize(name, list)
        @name = name
        @list = list
        @max_options = Scraper.configuration.max_list_options
      end

      def options
        @options ||= scrape_options
      end

      def select(option)
        previous_value = list.value
        list.select(option)

        @selection = option
        if list.value != previous_value
          changed
          notify_observers(self)
        end
      end

      private

      def scrape_options
        options = list.all('option').map { |option| option.text }.reject{|option| option =~ /\- *Select *\-/ }
        options = options[0, max_options] if max_options
        options
      end
    end
  end
end