require 'capybara'
require 'observer'

module Scraper
  module Elements

    class List
      attr_reader :name, :list

      def initialize(name, list)
        @name = name
        @list = list
        @options = find_options
      end

      def before_selection(&block)
        @before = block
      end

      def after_selection(&block)
        @after = block
      end

      def selection
        selected_option = @options.detect {|_, option| option.selected? }
        selected_option.length > 0 and selected_option[1].text
      end

      def options
        @options.keys
      end

      def select(option)
        return if already_selected(option)

        @before.call if @before
        list.select(option)
        @after.call if @after
      end

      private

      def already_selected(option)
        @options[option].selected?
      end

      def find_options
        options = list.all('option')
        options = options[0, Scraper.configuration.max_list_options] if Scraper.configuration.max_list_options
        Hash[options.map{|option| [option.text, option]}]
      end

    end
  end
end