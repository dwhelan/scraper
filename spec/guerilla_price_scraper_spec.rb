require './guerilla_price_scraper.rb'
require './spec/spec_helper'

describe GuerillaPriceScraper, :vcr do

  describe 'business cards' do

      before(:all) do
        @prices = GuerillaPriceScraper.new.scrape('business-cards-14-pt')
      end

      specify do
        @prices.should include ['100', '2in. x 3.5in. Business Cards', '4/0 - Full Color Front, No Back', 'Standard'] => 4595
      end
      specify do
        @prices.should include ['250', '2in. x 3.5in. Business Cards', '4/0 - Full Color Front, No Back', 'Standard'] => 4995
      end
      specify do
        @prices.should include ['100', '2in. x 3.5in. Business Cards', '4/4 - Full Color Both Sides',     'Standard'] => 4995
      end
      specify do
        @prices.should include ['100', '2in. x 3.5in. Business Cards', '4/0 - Full Color Front, No Back', 'UV Coating (Front Only)'] => 5595
      end
  end
end