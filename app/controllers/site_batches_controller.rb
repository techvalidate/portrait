class SiteBatchesController < ApplicationController
  before_action :user_required

  def show
    @site_batch = @current_user.site_batches.find_by(id: params[:id])
    if @site_batch.present?
      respond_to { |format| format.json }
    else
      render json: {errors: 'not found'}, status: 404
    end
  end

  def create
    @site_batch = @current_user.site_batches.create(site_batch_params)

    respond_to { |format| format.json }
  end

  private

  def site_batch_params
    params.require(:site_batch).permit(submitted_urls: [])
  end
end
