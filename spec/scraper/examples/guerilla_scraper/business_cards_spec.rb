require './spec/spec_helper'
require './lib/scraper/examples/guerilla_price_scraper'

module Scraper::Examples

  describe GuerillaPriceScraper, js: true do

    describe 'business cards', :vcr do

        let(:selections) {{
          'Quantity:'  => '100',
          'Size:'      => '2in. x 3.5in. Business Cards',
          'Colors:'    => '4/0 - Full Color Front, No Back',
          'Finishing:' => 'Standard',
        }}
        let(:price) { @prices[selections] }

        before(:all) { @prices = GuerillaPriceScraper.new.scrape('business-cards-14-pt', Scraper::Scrapers::CapybaraScraper.new) }

        context('base price')                  {                                                                      it { price.should == '$45.95' } }
        context('for a quantity of 250 price') { before { selections['Quantity:']  = '250' };                         it { price.should == '$49.95' } }
        context('for colors of 4/4 price')     { before { selections['Colors:']    = '4/4 - Full Color Both Sides' }; it { price.should == '$49.95' } }
        context('for UV coating price')        { before { selections['Finishing:'] = 'UV Coating (Front Only)' };     it { price.should == '$55.95' } }
    end
  end
end