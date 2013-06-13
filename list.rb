require 'capybara'
require 'observer'

class List

  include Observable

  private

  attr_reader :name, :list

  public

  def initialize(name, list)
    @name = name
    @list = list
  end

  def options
    list.all('option').map { |option| option.text }
  end

  def select(option)
    previous_value = list.value
    list.select(option)
    if list.value != previous_value
      changed
      notify_observers
    end
  end
end