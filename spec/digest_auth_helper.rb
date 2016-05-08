module DigestAuthHelpers

  def login_as(user_sym)
    user = users(user_sym)
    request.session[:user_id] = user.id if user
  end

end