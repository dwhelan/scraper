require './guerilla_price_scraper.rb'
require './spec/spec_helper'

describe GuerillaPriceScraper, :vcr do

  describe 'business cards', :vcr do

      let(:selections) {{
        'Quantity:'  => '100',
        'Size:'      => '2in. x 3.5in. Business Cards',
        'Colors:'    => '4/0 - Full Color Front, No Back',
        'Finishing:' => 'Standard',
      }}

      before(:all) { @prices = GuerillaPriceScraper.new.scrape('business-cards-14-pt') }

      context('base price')                  {                                                                    it { @prices[selections].should == 4595 } }
      context('for a quantity of 250 price') { before { selections['Quantity:']  = '250' };                       it { @prices[selections].should == 4995 } }
      context('for colors of 4/4 price')   { before { selections['Colors:']    = '4/4 - Full Color Both Sides' }; it { @prices[selections].should == 4995 } }
      context('for UV coating price')      { before { selections['Finishing:'] = 'UV Coating (Front Only)' };     it { @prices[selections].should == 5595 } }
  end
end