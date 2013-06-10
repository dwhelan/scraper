require './guerilla_price_scraper.rb'
require './spec/spec_helper'

describe GuerillaPriceScraper do

  describe 'business cards' do

    #before { subject.scrape('business-cards-14-pt') }

    #describe 'pricing variables' do
    #  its(:quantities) { should == ['100', '250', '500', '1000', '2500', '5000'] }
    #  its(:sizes)      { should == ['2in. x 3.5in. Business Cards'] }
    #  its(:sides)      { should == ['4/0 - Full Color Front, No Back', '4/4 - Full Color Both Sides'] }
    #  its(:finishes)   { should == ['Standard', 'UV Coating (Front Only)'] }
    #end

    describe 'foo' do
      let(:prices) { GuerillaPriceScraper.new.scrape('business-cards-14-pt') }

      specify { prices.should include ['100', '2in. x 3.5in. Business Cards', '4/0 - Full Color Front, No Back', 'Standard'] => 4595 }
      specify { prices.should include ['250', '2in. x 3.5in. Business Cards', '4/0 - Full Color Front, No Back', 'Standard'] => 4995 }
    end

    describe 'prices' do
      let(:options) { { quantity: '100', size: '2in. x 3.5in. Business Cards', side: '4/0 - Full Color Front, No Back', finish: 'Standard'} }

      describe "prices by quantity for => side: '4/0 - Full Color Front, No Back', finish: 'Standard'" do
        {'100' => 4595, '250' => 4995, '500' => 5995, '1000' => 7495, '2500' => 10200, '5000' => 11900}.each do |quantity, price|
          context("price for quantity: #{quantity}") do
            before  { options[:quantity] = quantity }
            specify { subject.price_for(options).should == price }
          end
        end
      end

      describe "prices by size for => quantity: '100', finish: 'Standard'" do
        {'4/0 - Full Color Front, No Back' => 4595, '4/4 - Full Color Both Sides' => 4995}.each do |side, price|
          context("price for size: #{side}") do
            before  { options[:side] = side }
            specify { subject.price_for(options).should == price }
          end
        end
      end

      describe "prices by finish => for quantity: '100', side: '4/0 - Full Color Front, No Back'" do
        {'Standard' => 4595, 'UV Coating (Front Only)' => 5595}.each do |finish, price|
          context("price for finish: #{finish}") do
            before  { options[:finish] = finish }
            specify { subject.price_for(options).should == price }
          end
        end
      end
    end

  end
end