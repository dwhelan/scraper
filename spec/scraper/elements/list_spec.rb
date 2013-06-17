require './lib/scraper/elements/list'
require './spec/support/vcr'
require './spec/support/capybara'
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
      its(:options) { should == %w(a b c) }
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

    describe 'should be observable' do
      let(:observer) do
        observer = Object.new

        class << observer
          attr_reader :fired
          def update() @fired = true end
        end
        observer
      end

      before do
        subject.select('a')
        subject.add_observer(observer)
      end

      it 'should notify when new option selected' do
        subject.select('b')
        observer.fired.should be_true
      end

      it 'should not notify when option already selected' do
        subject.select('a')
        observer.fired.should be_false
      end
    end
  end
end