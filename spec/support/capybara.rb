require 'capybara'
require 'capybara/poltergeist'

Capybara.default_driver = :selenium

#Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, {:debug => false})
#end
#
#Capybara.current_driver = :poltergeist
#Capybara.javascript_driver = :poltergeist
