class UserMailer < ApplicationMailer
  default from: 'noreply@portrait.mailinator.com'

  def create_and_send_password_change(user, new_password)
    @user = user
    @new_password = new_password
    subject = 'Here is your new Portrait password'
    mail(to:@user.email, subject: subject)
  end

end
