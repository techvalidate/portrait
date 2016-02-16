require 'rails_helper'

describe "Sites", type: :request do
  let(:user) { users(:joe) }
  let(:headers) { {'ACCEPT' => 'application/xml',
                   'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('joe:secret007')}" } }

  describe "POST /api/v1/sites" do
    context "with a valid URL" do
      before do
        allow(SiteCaptureJob).to receive(:perform_async).and_return(true)
        post '/api/v1/sites', { url: 'http://phantomjs.org' }, headers
      end

      it "should be successful" do
        expect(response).to be_success
      end

      it "should create a site record for the given user" do
        site = user.sites.first # actually the last created site
        expect(site.url).to eq('http://phantomjs.org')
      end

      it "should contain information about the site and its status" do
        site = user.sites.first # actually the last created site
        expect(response.body).to include("<status>#{site.status}</status>")
        expect(response.body).to include("<url>#{site.url}</url>")
        expect(response.body).to include("<link>http://www.example.com/api/v1/sites/#{site.id}</link>")
      end
    end

    context "with an invalid URL" do
      it "should fail a blank URL" do
        post '/api/v1/sites', { url: '' }, headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("<error>Url can't be blank</error>")
      end

      it "should fail an invalid URL" do
        post '/api/v1/sites', { url: '#invalid!~~~' }, headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("<error>Url is invalid</error>")
      end
    end
  end


  describe "GET /api/v1/sites/:id" do
    let(:site) { user.sites.create(url: 'http://phantomjs.org') }

    context "with a valid site belonging to the current user" do
      before do
        get "/api/v1/sites/#{site.id}", {}, headers
      end

      it "should be successful" do
        expect(response).to be_success
      end

      it "should return the correct site record" do
        expect(response.body).to include("<status>#{site.status}</status>")
        expect(response.body).to include("<url>#{site.url}</url>")
        expect(response.body).to include("<link>http://www.example.com/api/v1/sites/#{site.id}</link>")
      end
    end

    context "with an invalid site id" do
      before do
        get "/api/v1/sites/1000", {}, headers
      end

      it "should result in a 404" do
        expect(response).to have_http_status(404)
      end

      it "should have an error message" do
        expect(response.body).to include("Site does not exist")
      end
    end

    context "when trying to access a site that does not belong to the user" do
      before do
        other_site = users(:admin).sites.create(url: 'http://stackoverflow.com/')
        get "/api/v1/sites/#{other_site.id}", {}, headers
      end

      it "should result in a 401" do
        expect(response).to have_http_status(401)
      end

      it "should have an error message" do
        expect(response.body).to include("You are not authorized to accesss this site")
      end
    end
  end

  describe "GET /api/v1/sites/:id" do
    let!(:site) { user.sites.create(url: 'http://phantomjs.org') }
    before do
      get "/api/v1/sites", {}, headers
    end

    it "should be successful" do
      expect(response).to be_success
    end

    it "should return the last 20 (maximum) sites for the current user" do
      result = Hash.from_xml(response.body)
      expect(result["sites"].length).to eq(2)
    end

    it "should have data about the individual sites" do
      result = Hash.from_xml(response.body)
      first_site = result["sites"][0]["site"]
      expect(first_site["url"]).to eq(site.url)
      expect(first_site["status"]).to eq(site.status)
    end
  end
end