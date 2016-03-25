class User < ActiveRecord::Base
  has_secure_password

  before_create { generate_token(:auth_token) }

  # Class methods

  def self.authenticate(name, password)
    user = User.find_by name: name
    user.authenticate(password)
  end

  def self.generate_random_password
    Array.new(10).map { (65 + rand(58)).chr }.join
  end

  # Associations

  has_many :sites, dependent: :destroy

  # Instance Methods

  def to_param() name end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.reset_password(self).deliver_later
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # Validations

  validates :password, presence: true, on: :create
  validates :email, uniqueness:true, presence: true, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :name, uniqueness: true, format: /[a-z0-9]+/
end
