require './lib/scraper/elements/list'
require './lib/scraper/elements/list_collection'
require 'capybara'


require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {debug: false})
end

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.current_driver = :selenium

module Scraper
  module Examples

    class GuerillaPriceScraper

      include Capybara::DSL

      def scrape(page_path)
        Capybara.default_wait_time = 10
        visit "http://www.guerillaprinting.ca/#{page_path}"
        lists.select_all_list_combinations

        @prices
      end

      def on_list_selections_complete(selections)
        @prices ||= {}
        @prices[selections] = price
      end

      private

      LOADING_TEXT = ''

      def price_container
        @price_container_div = find('#updateDiv')
        @price_container_div.text
      end

      def price
        @price_div = find('div#total div.calcPrice')
        @price_div.text
      end

      def lists
        @lists || find_lists
      end

      def find_lists
        @lists = Scraper::Elements::ListCollection.new

        all('div.attributeDiv').each do |attribute_div|
          @lists.insert(find_list(attribute_div))
        end

        @lists.add_observer(self, :on_list_selections_complete)
        @lists
      end

      def find_list(attribute_div)
        name   = attribute_div.find('div.attributeName').text
        select = attribute_div.find('select.calcItem')
        list = Scraper::Elements::List.new(name, select)

        list.before_selection {
          page.execute_script(%Q(document.getElementById("updateDiv").innerHTML = '<p>#{LOADING_TEXT}</p>')) }
        list.after_selection  {
          wait_until { price_container != LOADING_TEXT } }

        list
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