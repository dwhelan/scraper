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

  def prices
    prices = {}
    quantities.each do |quantity|
      sizes.each do |size|
        sides.each do |side|
          finishes.each do |finish|
            prices[[quantity, size, side, finish]] = price_for(quantity: quantity, size: size, side: side, finish: finish)
          end
        end
      end
    end
    prices
  end

  private

  def price_for(options)
    options.each do |key, option|
      select_list_option(lists[key], option)
    end

    price
  end

  def select_list_option(list, option)
    old_price_container = price_container
    wait_until { price_updated(old_price_container) } if list.select(option)
  end

  def price_updated(old_price_container)
    new_price_container = price_container
    new_price_container != old_price_container and new_price_container != ''
  end

  def price_container
    page.find('#updateDiv').text
  end

  def price
    find('div#total div.calcPrice').text.gsub(/\D/, '').to_i
  end

  def lists
    unless @lists
      list_elements = all('.calcItem')
      @lists ||= {
        quantity: List.new(list_elements[0]),
        size:     List.new(list_elements[1]),
        side:     List.new(list_elements[2]),
        finish:   List.new(list_elements[3]),
    }
    end
    @lists
  end

  def quantities
    lists[:quantity].options
  end

  def sizes
    lists[:size].options
  end

  def sides
    lists[:side].options
  end

  def finishes
    lists[:finish].options
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until yield
    end
  end

end