class SiteBatchesController < ApplicationController
  before_action :user_required

  def create
    @site_batch = SiteBatch.new(site_batch_params.merge(user: @current_user))
    @site_batch.save
    respond_to do |format|
      format.json
    end
  end

  private

  def site_batch_params
    params.require(:site_batch).permit(:submitted_urls => [])
  end
end
