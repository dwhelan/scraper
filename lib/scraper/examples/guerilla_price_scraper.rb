require './lib/scraper/elements/list'
require './lib/scraper/elements/list_collection'
require 'capybara'

module Scraper
  module Examples

    class GuerillaPriceScraper

      include Capybara::DSL

      def scrape(page_path)
        Capybara.default_driver = :selenium
        Capybara.default_wait_time = 10
        visit "http://www.guerillaprinting.ca/#{page_path}"
        lists.select_all_list_combinations

        @prices
      end

      def on_list_option_changed
        old_price = old_price_container
        wait_until {
          new_price = price_container

          #TODO Does not handle situation where a new set of options has the same price as the previous set
          new_price != old_price and new_price != LOADING_TEXT
        }
        old_price_container = price_container
      end

      def on_list_selections_complete(selections)
        @prices ||= {}
        @prices[selections] = price
      end

      private

      attr_accessor :old_price_container

      LOADING_TEXT = ''

      def price_container
        @price_container_div ||= find('#updateDiv')
        @price_container_div.text
      end

      def price
        @price_div ||= find('div#total div.calcPrice')
        @price_div.text
      end

      def lists
        lists = Scraper::Elements::ListCollection.new

        all('div.attributeDiv').each do |attribute_div|
          list = find_list(attribute_div)
          list.add_observer(self, :on_list_option_changed)
          lists.insert(list)
        end

        lists.add_observer(self, :on_list_selections_complete)
        lists
      end

      def find_list(attribute_div)
        name   = attribute_div.find('div.attributeName').text
        select = attribute_div.find('select.calcItem')
        Scraper::Elements::List.new(name, select)
      end

      def wait_until
        require 'timeout'
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      end
    end
  end
end