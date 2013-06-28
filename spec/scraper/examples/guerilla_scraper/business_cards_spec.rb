require_relative '../../../../lib/scraper'
require_relative '../../../../lib/scraper/examples/guerilla_price_scraper'
require_relative '../../../spec_helper'

module Scraper::Examples

  describe GuerillaPriceScraper, js: true do

    [:selenium, :poltergeist].each do |driver_name|
      describe " business cards via #{driver_name}", :vcr do

          let(:selections) {{
            'Quantity:'  => '100',
            'Size:'      => '2in. x 3.5in. Business Cards',
            'Colors:'    => '4/0 - Full Color Front, No Back',
            'Finishing:' => 'Standard',
          }}
          let(:price) { @prices[selections] }

          before(:all) do
            scraper = GuerillaPriceScraper.new(Scraper::Scrapers::CapybaraScraper.new(driver_name))
            scraper.scrape('business-cards-14-pt')
            @prices = scraper.price_list
          end

          context('base price')                  {                                                                      it { price.should == '$45.95' } }
          context('for a quantity of 250 price') { before { selections['Quantity:']  = '250' };                         it { price.should == '$49.95' } }
          context('for colors of 4/4 price')     { before { selections['Colors:']    = '4/4 - Full Color Both Sides' }; it { price.should == '$49.95' } }
          context('for UV coating price')        { before { selections['Finishing:'] = 'UV Coating (Front Only)' };     it { price.should == '$55.95' } }
      end
    end
  end
end