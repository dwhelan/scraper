require './list'
require './list_collection'
require 'capybara'

class GuerillaPriceScraper

  include Capybara::DSL

  def scrape(page_path)
    Capybara.default_driver = :selenium
    Capybara.default_wait_time = 10
    visit "http://www.guerillaprinting.ca/#{page_path}"
    prices
  end

  def on_list_option_changed
    old_price = price_container
    wait_until {
      new_price = price_container

      #TODO Does not handle situation where a new set of options has the same price as the previous set
      new_price != old_price and new_price != LOADING_TEXT
    }
  end

  def on_list_selections_complete(selections)
    @prices[selections] = price
  end

  private

  def prices
    @prices = {}

    lists.select_all_list_combinations

    @prices
  end

  LOADING_TEXT = ''

  def price_container
    find('#updateDiv').text
  end

  def price
    find('div#total div.calcPrice').text.gsub(/\D/, '').to_i
  end

  def lists
    lists = ListCollection.new

    all('div.attributeDiv').each do |attribute_div|
      lists.insert(extract_list(attribute_div))
    end

    lists.add_observer(self, :on_list_selections_complete)
    lists
  end

  def extract_list(attribute_div)
    name   = attribute_div.find('div.attributeName').text
    select = attribute_div.find('select.calcItem')
    list   = List.new(name, select)

    list.add_observer(self, :on_list_option_changed)
    list
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until yield
    end
  end

end