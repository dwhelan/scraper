# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scraper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Declan Whelan']
  gem.email         = ['declan@printchomp.com']
  gem.description   = 'A gem for scraping'
  gem.summary       = ''
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'Prices'
  gem.require_paths = ['lib']
  gem.version       = Scraper::VERSION
end
