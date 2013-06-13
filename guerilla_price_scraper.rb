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

  private

  def prices
    prices = {}

    # Sequence option selections for maximum price variability by placing most price sensitive options later
    finishes.each do |finish|
      sides.each do |side|
        sizes.each do |size|
          quantities.each do |quantity|
            prices[[quantity, size, side, finish]] = price_for('Quantity' => quantity, 'Size' => size, 'Colors' => side, 'Finishing' => finish)
          end
        end
      end
    end
    prices
  end

  def price_for(options)
    options.each do |key, option|
      select_option(lists[key], option)
    end

    price
  end

  def select_option(list, option)
    old_price = price_container
    wait_until { price_updated_from(old_price) } if list.select(option)
  end

  LOADING_TEXT = ''

  def price_updated_from(old_price)
    new_price = price_container

    #TODO Does not handle situation where a new set of options has the same price as the previous set
    new_price != old_price and new_price != LOADING_TEXT
  end

  def price_container
    find('#updateDiv').text
  end

  def price
    find('div#total div.calcPrice').text.gsub(/\D/, '').to_i
  end

  def lists
    unless @lists
      @lists = {}

      all('div.attributeDiv').each do |attribute_div|
        extract_list(attribute_div)
      end
    end
    @lists
  end

  def extract_list(attribute_div)
    name = attribute_div.find('div.attributeName').text.sub(/[[:punct:]]\Z/, '')
    select = attribute_div.find('select.calcItem')
    @lists[name] = List.new(select)
  end

  def quantities
    lists['Quantity'].options
  end

  def sizes
    lists['Size'].options
  end

  def sides
    lists['Colors'].options
  end

  def finishes
    lists['Finishing'].options
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until yield
    end
  end

end