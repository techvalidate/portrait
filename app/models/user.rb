class User < ApplicationRecord

  has_secure_password
  attr_accessor :reset_token

  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true


  has_many :sites, dependent: :destroy

  scope :by_name, ->{ order(name: :asc) }

  def to_param() name end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
