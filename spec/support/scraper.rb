require './lib/scraper/scraper.rb'

Scraper.configure do |c|
  c.max_list_options = 2
end