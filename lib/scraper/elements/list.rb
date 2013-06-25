require 'capybara'
require 'observer'

module Scraper
  module Elements

    class List
      attr_reader :name, :list, :max_options

      public

      def before_selection(&block)
        @before = block
      end

      def after_selection(&block)
        @after = block
      end

      def selection
        selected_option = @options.detect {|text, option| option.selected? }
        selected_option.length > 0 and selected_option[1].text
      end

      def initialize(name, list)
        @name = name
        @list = list
        @max_options = Scraper.configuration.max_list_options
        @options = scrape_opts
      end

      def options
        @options.keys
      end

      def select(option)
        #puts list.find('option:selected')
        option_node = @options[option]
        return if option_node.selected?
        @before.call if @before
        list.select(option)
        @selection = option
        @after.call if @after
      end

      private

      def option_already_selected(option)
        list
      end

      def scrape_opts
        options = list.all('option')
        options = options[0, max_options] if max_options
        Hash[options.map{|option| [option.text, option]}]

      end

      def scrape_options
        options = list.all('option').map { |option| option.text }.reject{|option| option =~ /\- *Select *\-/ }
        options = options[0, max_options] if max_options
        options
      end
    end
  end
end