class User < ActiveRecord::Base

  has_secure_password

  has_many :sites, dependent: :destroy

  def to_param() name end

  validates :password_digest, presence: true
  validates :name, uniqueness: true, format: /[a-zA-Z0-9]+/
  validates :email, uniqueness: true, format: /^.+@.+\..+$/

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
end
