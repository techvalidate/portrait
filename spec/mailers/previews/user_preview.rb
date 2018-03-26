# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user/forgot_password
  def forgot_password
    UserMailer.forgot_password
  end

end
