require './lib/scraper/elements/list_collection'
require 'observer'

module Scraper::Elements

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

    describe '#select_all_list_combinations' do
      let(:all_selections) { [] }

      it 'should observe all list combinations being selected' do
        subject.after_selection { all_selections << subject.selections }
        subject.select_all_list_combinations
        all_selections.should include {{ 'list1' => 'a', 'list2' => 'x' }}
      end
    end
  end
end
