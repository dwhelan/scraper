require 'capybara'
require 'capybara/poltergeist'
require 'timeout'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {debug: false})
end

Capybara.current_driver    = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 10

#Capybara.current_driver = :selenium

module Scraper
  module Scrapers
    class CapybaraScraper

      include Capybara::DSL

      def initialize(driver_name)
        Capybara.current_driver = driver_name
      end

      def visit(url)
        page.visit(url)
      end

      def find(*args)
        page.find(*args)
      end

      def find_all(*args)
        page.all(*args)
      end

      def execute_script(*args)
        page.execute_script(*args)
      end

      def wait_until
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      end
    end
  end
end