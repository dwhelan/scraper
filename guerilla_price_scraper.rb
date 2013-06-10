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
    quantities.each do |quantity|
      sizes.each do |size|
        sides.each do |side|
          finishes.each do |finish|
            result[[quantity, size, side, finish]] = price_for(quantity, size, side, finish)
          end
        end
      end
    end
    result
  end

  def price_for(quantity, size, side, finish)
    calculatorSelections[0].select(quantity)
    calculatorSelections[1].select(size)
    calculatorSelections[2].select(side)
    calculatorSelections[3].select(finish)
    sleep 1
    price
  end

  #def price_for(options)
  #  calculatorSelections[0].select(options[:quantity])
  #  calculatorSelections[1].select(options[:size])
  #  calculatorSelections[2].select(options[:side])
  #  calculatorSelections[3].select(options[:finish])
  #  price
  #end
  private

  def quantities
    options(calculatorSelections[0])
  end

  def sizes
    options(calculatorSelections[1])
  end

  def sides
    options(calculatorSelections[2])
  end

  def finishes
    options(calculatorSelections[3])
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