require 'capybara'
require 'observer'

module Scraper
  module Elements

    class ListCollection

      def initialize
        @lists = []
      end

      def after_selection(&block)
        @after = block
      end

      def << (list)
        @lists << list
      end

      def select_all_list_combinations
        _select_all_list_combinations(lists)
      end

      def selections
        Hash[lists.map{|list| [list.name, list.selection]}]
      end

      private

      attr_reader :lists

      def _select_all_list_combinations(lists_to_enumerate)
        list = lists_to_enumerate[0]
        list.options.each do |option|
          list.select(option)
          if lists_to_enumerate.length > 1
            _select_all_list_combinations(lists_to_enumerate.slice(1..-1))
          else
            @after.call if @after
          end
        end
      end

    end
  end
end