require 'capybara'
require 'observer'

module Scraper
  module Elements

    class ListCollection

      include Observable

      private

      attr_reader :lists

      public

      def initialize
        @lists = []
      end

      def insert(list)
        @lists.insert(0, list)
      end

      def select_all_list_combinations
        _select_all_list_combinations(lists)
      end

      def selections
        Hash[lists.map{|list| [list.name, list.selection]}]
      end

      private

      def _select_all_list_combinations(lists_to_enumerate)
        list = lists_to_enumerate[0]
        list.options.reverse.each do |option|
          list.select(option)
          if lists_to_enumerate.length > 1
            _select_all_list_combinations(lists_to_enumerate.slice(1..-1))
          else
            changed
            notify_observers(selections)
          end
        end
      end

    end
  end
end