require_relative 'configuration'
require_relative 'elements'

module Scraper

  extend self

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end
end