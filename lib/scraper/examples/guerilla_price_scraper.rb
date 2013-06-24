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

      def scrape(page_path)
        Capybara.default_wait_time = 10
        visit "http://www.guerillaprinting.ca/#{page_path}"
        lists.select_all_list_combinations

        @prices
      end

      def on_list_option_changed(list)
        #puts "#{list.name} - selected #{list.selection}"
        old_price = old_price_container
        keep_waiting_prices = [old_price, LOADING_TEXT, '']
        wait_until {
          new_price = price_container

          #TODO Does not handle situation where a new set of options has the same price as the previous set
          keep_waiting = keep_waiting_prices.include?(new_price)
          #puts "for #{lists.selections}; old_price=#{old_price}, new_price=#{new_price}; keep_waiting=#{keep_waiting}"
          !keep_waiting
        }
        @old_price_container = price_container
      rescue Timeout::Error
        puts 'timeout warning - just using the last scraped value'
      end

      def on_list_selections_complete(selections)
        @prices ||= {}
        @prices[selections] = price
        #puts "saved price for #{selections}; price=#{@prices[selections]}"
      end

      private

      attr_accessor :old_price_container

      LOADING_TEXT = ''

      def old_price_container
        @old_price_container ||= price_container
      end

      def price_container
        @price_container_div = find('#updateDiv')
        @price_container_div.text
      end

      def price
        @price_div = find('div#total div.calcPrice')
        @price_div.text
      end

      def lists
        @lists ||=
          begin
            lists = Scraper::Elements::ListCollection.new

            all('div.attributeDiv').each do |attribute_div|
              list = find_list(attribute_div)
              list.add_observer(self, :on_list_option_changed)
              lists.insert(list)
            end

            lists.add_observer(self, :on_list_selections_complete)
            lists
          end
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