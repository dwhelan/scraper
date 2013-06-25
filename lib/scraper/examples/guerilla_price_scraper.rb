require './lib/scraper/elements/list'
require './lib/scraper/elements/list_collection'
require 'capybara'


require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {debug: false})
end

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

#Capybara.current_driver = :selenium

module Scraper
  module Examples

    class GuerillaPriceScraper

      include Capybara::DSL

      def initialize(scraper)
        @scraper = scraper
        @prices = {}
      end

      def scrape(page_path)
        scraper.visit("http://www.guerillaprinting.ca/#{page_path}")
        create_lists.select_all_list_combinations
        @prices
      end

      def on_list_selections_complete(selections)
        @prices[selections] = price
      end

      private

      attr_reader :scraper

      LOADING_TEXT = ''

      def price_container
        @price_container_div ||= scraper.find('#updateDiv')
        @price_container_div.text
      end

      def price
        scraper.find('div#total div.calcPrice').text
      end

      def create_lists
        lists = Scraper::Elements::ListCollection.new
        lists.add_observer(self, :on_list_selections_complete)

        scraper.find_all('div.attributeDiv').each do |attribute_div|
          lists.insert(create_list(attribute_div))
        end

        lists
      end

      def create_list(attribute_div)
        name   = attribute_div.find('div.attributeName').text
        select = attribute_div.find('select.calcItem')
        list   = Scraper::Elements::List.new(name, select)

        list.before_selection { page.execute_script(%Q(document.getElementById("updateDiv").innerHTML = '<p>#{LOADING_TEXT}</p>')) }
        list.after_selection  { scraper.wait_until { price_container != LOADING_TEXT } }

        list
      end

    end
  end
end