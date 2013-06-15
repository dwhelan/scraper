require './list_collection.rb'
require 'observer'

class FakeList
  attr_reader :name, :options, :selection

  def initialize(name, options)
    @name    = name
    @options = options
  end

  def select(option)
    @selection = option
  end
end

describe ListCollection do

  let(:list1) { FakeList.new('list1', %w(a b)) }
  let(:list2) { FakeList.new('list2', %w(x y)) }

  before do
    subject << list1
    subject << list2
  end

  describe '#selections' do
    before do
      list1.select('a')
      list2.select('x')
    end

    context('after selecting "a" in list1 and "x" in list2') { its(:selections) { should == {'list1' => 'a', 'list2' => 'x'} } }
  end

  it '#select_all_list_combinations' do
    class Observer
      attr_reader :fired, :all_selections
      def initialize() @all_selections = [] end
      def update(selections) all_selections << selections end
    end

    observer = Observer.new
    subject.add_observer(observer)
    subject.select_all_list_combinations
    observer.all_selections.should == [
      { 'list1' => 'a', 'list2' => 'x' },
      { 'list1' => 'a', 'list2' => 'y' },
      { 'list1' => 'b', 'list2' => 'x' },
      { 'list1' => 'b', 'list2' => 'y' },
    ]
  end

end