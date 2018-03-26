class UserMailer < ApplicationMailer
  def forgot_password(user)
    @user = user
    @greeting = "Hi"

    mail to: user.email, :subject => 'Reset password instructions'
  end
end
