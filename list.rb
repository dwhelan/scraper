require 'capybara'

class List

  private

  attr_reader :list

  public

  def initialize(list)
    @list = list
  end

  def options
    list.all('option').map { |option| option.text }
  end

  def select(option)
    previous_value = list.value
    list.select(option)
    list.value != previous_value
  end
end