require './list'
require 'capybara'

class GuerillaPriceScraper

  include Capybara::DSL

  def scrape(page_path)
    Capybara.default_driver = :selenium
    visit "http://www.guerillaprinting.ca/#{page_path}"
    prices
  end

  def prices
    result = {}
    quantities.options.each do |quantity|
      sizes.options.each do |size|
        sides.options.each do |side|
          finishes.options.each do |finish|
            #result[[quantity, size, side, finish]] = price_for(quantity: quantity, size: size, side: side, finish: finish)
            result[[quantity, size, side, finish]] = price_for(quantity, size, side, finish)
          end
        end
      end
    end
    result
  end

  def price_for2(options)
    options.each do |key, option|
      update_selection(lists[key], option)
    end

    price
  end

  def price_for(quantity, size, side, finish)
    update_selection(quantities, quantity)
    update_selection(sizes, size)
    update_selection(sides, side)
    update_selection(finishes, finish)

    price
  end

  def update_selection(list, option)
    old_price_container = price_container
    wait_until { price_container != old_price_container } if list.select(option)
  end


  private

  def price_updated(old_price_container)
    price_container_text = price_container
    price_container_text != old_price_container and price_container_text != ''
  end

  def price_container
    page.find('#updateDiv').text
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until yield
    end
  end

  def lists
    @lists ||= {
      quantity: List.new(calculatorSelections[0]),
      size: List.new(calculatorSelections[1]),
      side: List.new(calculatorSelections[2]),
      finish: List.new(calculatorSelections[3]),
    }
  end

  def quantities
    @quantities ||= List.new(calculatorSelections[0])
  end

  def sizes
    @sizes ||= List.new(calculatorSelections[1])
  end

  def sides
    @sides ||= List.new(calculatorSelections[2])
  end

  def finishes
    @finishes ||= List.new(calculatorSelections[3])
  end

  def price
    find('div#total div.calcPrice').text.gsub(/\D/, '').to_i
  end

  def calculatorSelections
    @calculatorSelections ||= all('.calcItem')
  end

  def options(select)
    select.all('option').map { |node| node.text }
  end
end