require './lib/scraper/elements/list'
require './spec/spec_helper'
require 'observer'

module Scraper::Elements

  describe List do

    before :all do
      Capybara.current_session.visit "file://localhost#{Dir.pwd}/spec/scraper/elements/list_spec.html"
      @list = Capybara.current_session.all('#id')[0]
    end

    subject { List.new('foo', @list) }

    its(:name) { should == 'foo'}

    describe '#options' do
      its(:options) { should == %w(a b) }
      it 'should cache options' do
        subject.options
        @list.should_not_receive(:all)
        subject.options
      end
    end

    describe '#max_options' do
      describe('should default to Scraper configuration value') { its(:max_options) { should == Scraper.configuration.max_list_options }}
      context('with max_options = 1')   { before {subject.max_options = 1};   its(:options) { should == %w(a) } }
      context('with max_options = nil') { before {subject.max_options = nil}; its(:options) { should == %w(a b c) } }
    end

    describe '#select' do
      before { subject.select('a') }

      it 'should select list option' do
        @list.value.should == '1'
      end

    end

    describe '#text' do
      before { subject.select('a') }

      its(:selection) { should == 'a' }
    end

    describe '#before_selection' do
      it 'should notify' do
        fired = false
        subject.before_selection { fired = true }
        subject.select('a')
        fired.should be_true
      end

      it 'should notify before new option selected' do
        subject.select('a')
        subject.before_selection { subject.selection.should == 'a' }
        subject.select('b')
      end
    end

    describe '#after_selection' do
      it 'should notify' do
        fired = false
        subject.after_selection { fired = true }
        subject.select('a')
        fired.should be_true
      end

      it 'should notify before new option selected' do
        subject.select('a')
        subject.after_selection { subject.selection.should == 'b' }
        subject.select('b')
      end
    end
  end
end