require 'capybara'
require 'observer'

module Scraper
  module Elements

    class List
      attr_reader :name, :list, :selection
      attr_accessor :max_options

      public

      def before_selection(&block)
        @before = block
      end

      def after_selection(&block)
        @after = block
      end

      def initialize(name, list)
        @name = name
        @list = list
        @max_options = Scraper.configuration.max_list_options
      end

      def options
        @options ||= scrape_options
      end

      def select(option)
        #puts list.find('option:selected')
        #return if list.text == option
        @before.call if @before
        list.select(option)
        @selection = option
        @after.call if @after
      end

      private

      def selected_option
        list
      end

      def scrape_options
        options = list.all('option').map { |option| option.text }.reject{|option| option =~ /\- *Select *\-/ }
        options = options[0, max_options] if max_options
        options
      end
    end
  end
end