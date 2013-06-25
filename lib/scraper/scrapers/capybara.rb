require 'capybara'
require 'timeout'

module Scraper
  module Scrapers
    class CapybaraScraper

      def initialize
        Capybara.default_wait_time = 10
      end

      def visit(url)
        Capybara.visit(url)
      end

      def find(*args)
        Capybara.find(*args)
      end

      def find_all(*args)
        Capybara.all(*args)
      end

      def wait_until
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      end
    end
  end
end