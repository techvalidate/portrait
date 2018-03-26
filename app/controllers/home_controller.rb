class HomeController < ApplicationController
  layout 'home'

  before_action :set_user

  def index
  end

  private
    def set_user
      @current_user = User.find_by_id session[:user_id]
    end
end
