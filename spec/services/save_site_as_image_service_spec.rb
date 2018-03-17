require 'rails_helper'

describe SaveSiteAsImageService do

  describe 'self.run' do

    before do
      Site.skip_callback(:create, :after, :process!)
    end

    after do
      Site.set_callback(:create, :after, :process!)
    end

    before(:each) do
      @file_path = Rails.root.to_s + '/spec/tmp/middle_path.png'
      support_file_path = Rails.root.to_s + '/spec/support/images/middle_path.png'
      FileUtils.cp(support_file_path, @file_path)
      allow(described_class).to receive(:generate_png) { @file_path }
      @site = create(:site, url: 'http://middlepathdevelopment.com')
    end

    after(:each) do
      # TODO: do we need this ? does ActiveStorage store the asset when testing ?
      # @site.image.destroy
    end

    it "should return true if the image was successfully created" do
      res = described_class.run(@site)
      expect(res).to be_truthy
    end

    it "should clear out the temporary directory if the image was successfully created" do
      described_class.run(@site)
      support_directory = Rails.root.to_s + '/spec/tmp'
      expect(Dir["#{support_directory}/*"].empty?).to be_truthy
    end

    it "should return false if it cannot find the image path" do
      allow(described_class).to receive(:generate_png) { '/does/not/exist.png' }
      res = described_class.run(@site)
      expect(res).to be_falsey
    end

    it "should return false if it fails attaching the image" do
      allow(@site.image).to receive(:attach) { false }
      res = described_class.run(@site)
      expect(res).to be_falsey
    end

  end
end
