require './list'
require './spec/spec_helper'
require 'observer'

describe List do

  before :all do
    Capybara.default_driver = :selenium
    Capybara.current_session.visit "file://localhost#{Dir.pwd}/spec/html/list.html"
    @list = Capybara.current_session.all('#id')[0]
  end

  subject { List.new('foo', @list) }

  its(:name) { should == 'foo'}

  describe '#options' do
    its(:options) { should == %w(a b c) }
  end

  describe '#select' do
    before { subject.select('a') }

    it 'should select list option' do
      @list.value.should == '1'
    end

  end

  describe 'should be observable' do
    class Observer
      attr_reader :fired
      def update() @fired = true end
    end

    before do
      subject.select('a')
      @observer = Observer.new
      subject.add_observer(@observer)
    end

    it 'should notify when new option selected' do
      subject.select('b')
      @observer.fired.should be_true
    end

    it 'should not notify when option already selected' do
      subject.select('a')
      @observer.fired.should be_false
    end
  end

end