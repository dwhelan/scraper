require './list'
require './spec/spec_helper'

describe List do

  before :all do
    Capybara.default_driver = :selenium
    Capybara.current_session.visit "file://localhost#{Dir.pwd}/spec/html/list.html"
    @list = Capybara.current_session.all('#id')[0]
  end

  subject { List.new(@list) }

  describe '#options' do
    its(:options) { should == %w(a b c) }
  end

  describe '#select' do
    before { subject.select('a') }

    it 'should select list option' do
      @list.value.should == '1'
    end

    it 'should return "true" when new option selected' do
      subject.select('b').should be_true
    end

    it 'should return "false" when option already selected' do
      subject.select('a').should be_false
    end
  end
end