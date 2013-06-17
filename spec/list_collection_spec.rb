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
    subject.insert list2
    subject.insert list1
  end

  describe '#selections' do
    before do
      list1.select('a')
      list2.select('x')
    end

    context('after selecting "a" in list1 and "x" in list2') { its(:selections) { should == {'list1' => 'a', 'list2' => 'x'} } }
  end

  describe '#select_all_list_combinations' do
    let(:observer) do
      observer = Object.new

      class << observer
        attr_reader :fired
        def update(selections) all_selections << selections end
        def all_selections() @all_selections ||= [] end
      end
      observer
    end

    it 'should observe all list combinations being selected' do
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

end