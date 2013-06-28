require_relative '../../scraper'

module Scraper
  module Examples

    class GuerillaPriceScraper

      attr_reader :price_list

      def initialize(scraper)
        @scraper = scraper
        @price_list = {}
      end

      def scrape(page_path)
        scraper.visit("http://www.guerillaprinting.ca/#{page_path}")
        create_lists.select_all_list_combinations
      end

      private

      attr_reader :scraper

      LOADING_TEXT = ''

      def create_lists
        lists = Scraper::Elements::ListCollection.new
        lists.after_selection { @price_list[lists.selections] = price }

        scraper.find_all('div.attributeDiv').each do |attribute_div|
          lists << create_list(attribute_div)
        end

        lists
      end

      def create_list(attribute_div)
        name   = attribute_div.find('div.attributeName').text
        select = attribute_div.find('select.calcItem')
        list   = Scraper::Elements::List.new(name, select)

        list.before_selection { scraper.execute_script(%Q(document.getElementById("updateDiv").innerHTML = '#{LOADING_TEXT}')) }
        list.after_selection  { scraper.wait_until { price_container != LOADING_TEXT } }

        list
      end

      def price_container
        @price_container_div ||= scraper.find('#updateDiv')
        @price_container_div.text
      end

      def price
        scraper.find('div#total div.calcPrice').text
      end

    end
  end
end