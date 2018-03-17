require 'rails_helper'

describe ImageCacheSearchService do

  describe 'self.run' do

    before do
      Site.skip_callback(:create, :after, :process!)
    end

    after do
      Site.set_callback(:create, :after, :process!)
    end

    before(:each) do
      @url = 'http://middlepathdevelopment.com'
      @existing_site = create(:site, url: @url)
      @new_site = create(:site, url: @url)
    end

    it "should return an existing site (with image) if a fresh (less than 24 hours) site is found locally" do
      res = described_class.run(@new_site)
      expect(res).to be_truthy
      expect(res.url).to eq(@url)
    end

    it "should not return an existing site if a site is not found locally" do
      @existing_site.update_attribute(:url, 'http://somebs.com')
      res = described_class.run(@new_site)
      expect(res).to be_falsey
    end

    it "should not return an existing site if a stale site is found locally" do
      @existing_site.update_attribute(:created_at, Time.zone.now - 1.week)
      res = described_class.run(@new_site)
      expect(res).to be_falsey
    end
  end

end
