class UserMailer < ApplicationMailer
  default from: 'noreply@portrait.mailinator.com'

  def reset_password(user)
    @user = user
    subject = 'Instructions to reset your password'
    mail(to:@user.email, subject: subject)
  end

end
