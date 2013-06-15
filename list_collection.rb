require 'capybara'
require 'observer'

class ListCollection

  include Observable

  private

  attr_reader :lists

  public

  def initialize()
    @lists = []
  end

  def << (list)
    @lists << list
  end

  def select_all_list_combinations(x=lists)
    list = x[0]
    list.options.each do |option|
      list.select(option)
      if x.length > 1
        select_all_list_combinations(x.slice(1..-1))
      else
        changed
        notify_observers(selections)
      end
    end
  end

  def selections
    Hash[lists.map{|list| [list.name, list.selection]}]
  end

end