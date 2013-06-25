require 'capybara'

module Scraper
  module Scrapers
    class CapybaraScraper

      def wait_until
        require 'timeout'
        Timeout.timeout(Capybara.default_wait_time) do
          sleep(0.1) until yield
        end
      end

    end
  end
end