module Api
  module V1
    class SitesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action  :authenticate_user!

      def index
        @sites = current_user.sites.last(20)
        respond_to do |format|
          format.xml { render xml: @sites.map{|site| {site: site_info(site)} }.to_xml(root: "sites") }
        end
      end

      def show
        @site = Site.find_by(id: params[:id])
        respond_to do |format|
          if @site && @site.user_id == current_user.id
            format.xml { render xml: site_info(@site).to_xml(root: "site") }
          elsif @site.present?
            format.xml { render xml: "You are not authorized to accesss this site", status: 401 }
          else
            format.xml { render xml: "Site does not exist", status: 404 }
          end
        end
      end

      def create
        @site = current_user.sites.build url: params[:url]
        respond_to do |format|
          if @site.save
            format.xml { render xml: site_info(@site).to_xml(root: "site") }
          else
            format.xml { render xml: @site.errors.to_xml, status: 422 }
          end
        end
      end


      private

      def site_info(site)
        h = {
          url: site.url,
          status: site.status,
          link: api_v1_site_url(site) # this cannot be generated (easily) in the model
        }
        site.image.present? ? h.merge({ image_url: site.image_url }) : h
      end
    end
  end
end