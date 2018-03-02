class SiteBatchesController < ApplicationController
  before_action :user_required

  def show
    @site_batch = SiteBatch.find(params[:id])

    respond_to { |format| format.json }
  end

  def create
    @site_batch = SiteBatch.new(site_batch_params.merge(user: @current_user))
    @site_batch.save

    respond_to { |format| format.json }
  end

  private

  def site_batch_params
    params.require(:site_batch).permit(:submitted_urls => [])
  end
end
