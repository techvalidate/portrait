module UserHelper
  def save_first_user(attr, customer)
    user = User.new(attr)
    user.admin = true
    user.active = true
    user.customer = customer
    if user.save
      session[:user_id] = user.id
    else
      flash[:warn] = "User could not be saved"
      false
    end
  end

  def customer_users
    current_customer.all_users.order('name')
  end
end