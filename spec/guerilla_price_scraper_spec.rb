require './guerilla_price_scraper.rb'
require './spec/spec_helper'

describe GuerillaPriceScraper, :vcr do

  describe 'business cards', :vcr do

      let(:selections) {{
        'Quantity'  => '100',
        'Size'      => '2in. x 3.5in. Business Cards',
        'Colors'    => '4/0 - Full Color Front, No Back',
        'Finishing' => 'Standard'\
      }}

      before(:all) { @prices = GuerillaPriceScraper.new.scrape('business-cards-14-pt') }

      specify do
        @prices.should include selections => 4595
      end

      specify do
        selections['Quantity'] = '250'
        @prices.should include selections => 4995
      end

      specify do
        selections['Colors'] = '4/4 - Full Color Both Sides'
        @prices.should include selections => 4995
      end

      specify do
        selections['Finishing'] = 'UV Coating (Front Only)'
        @prices.should include selections => 5595
      end
  end
end