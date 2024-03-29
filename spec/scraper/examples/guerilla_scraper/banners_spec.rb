require_relative '../../../../lib/scraper/examples/guerilla_price_scraper'
require_relative '../../../spec_helper'

module Scraper::Examples

  describe GuerillaPriceScraper do

    [:selenium, :poltergeist].each do |driver_name|

      describe " #{driver_name} banners" do

        let(:selections) {{
          'Quantity:'  => '1',
          'Size:'      => '24in. x 36in. Banner',
          'Grommets:'  => '-Select-',
        }}
        let(:price) { @prices[selections] }

        before(:all) do
          scraper = GuerillaPriceScraper.new(Scraper::Scrapers::CapybaraScraper.new(driver_name))
          scraper.scrape('13-oz.-banners')
          @prices = scraper.price_list
        end

        context('base price')                       {                                                              it { price.should == '$40.50' } }
        context('for a quantity of 2 price')        { before { selections['Quantity:'] = '2' };                    it { price.should == '$81.00' } }
        context('for a size of 24in. x 48in price') { before { selections['Size:']     = '24in. x 48in. Banner' }; it { price.should == '$54.00' } }
        context('with no grommets price')           { before { selections['Grommets:'] = 'No' };                   it { price.should == '$40.50' } }
      end
    end
  end
end