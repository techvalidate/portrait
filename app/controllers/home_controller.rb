class HomeController < ApplicationController
  skip_before_action :admin_required

  # GET /
  def index
  end

end
