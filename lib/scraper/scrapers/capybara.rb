require 'capybara'
require 'timeout'

module Scraper
  module Scrapers
    class CapybaraScraper

      def initialize
        Capybara.default_wait_time = 10
      end

      def wait_until
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      end

      def visit(url)
        Capybara.visit(url)
      end
    end
  end
end