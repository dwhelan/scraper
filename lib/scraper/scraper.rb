require './lib/scraper/configuration.rb'

module Scraper

  extend self

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end
end