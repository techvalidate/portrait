class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_filter :admin_required

  # GET /
  def index
  end
  
end