require './list'
require 'capybara'

class GuerillaPriceScraper

  include Capybara::DSL

  def scrape(page_path)
    Capybara.default_driver = :selenium
    Capybara.default_wait_time = 10
    visit "http://www.guerillaprinting.ca/#{page_path}"
    prices
  end

  def list_option_changed
    old_price = price_container
    wait_until {
      new_price = price_container

      #TODO Does not handle situation where a new set of options has the same price as the previous set
      new_price != old_price and new_price != LOADING_TEXT
    }
  end

  private

  def prices
    prices = {}

    # Sequence option selections for maximum price variability by placing most price sensitive options later
    lists[3].options.each do |finish|
      lists[3].select(finish)
      lists[2].options.each do |side|
        lists[2].select(side)
        lists[1].options.each do |size|
          lists[1].select(size)
          lists[0].options.each do |quantity|
            lists[0].select(quantity)
            prices[[quantity, size, side, finish]] = price
          end
        end
      end
    end
    prices
  end


  LOADING_TEXT = ''


  def price_container
    find('#updateDiv').text
  end

  def price
    find('div#total div.calcPrice').text.gsub(/\D/, '').to_i
  end

  def lists
    unless @lists
      @lists = []

      all('div.attributeDiv').each do |attribute_div|
        extract_list(attribute_div)
      end
    end
    @lists
  end

  def extract_list(attribute_div)
    name = attribute_div.find('div.attributeName').text.sub(/[[:punct:]]\Z/, '')
    select = attribute_div.find('select.calcItem')
    list = List.new(name, select)
    list.add_observer(self, :list_option_changed)
    @lists << list
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until yield
    end
  end

end