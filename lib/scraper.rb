require_relative 'scraper/configuration'
require_relative 'scraper/elements'
require_relative 'scraper/scrapers'

module Scraper

  extend self

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end
end