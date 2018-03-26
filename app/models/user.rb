class User < ApplicationRecord
  has_secure_password

  has_many :sites, dependent: :destroy

  has_many :users_roles
  has_many :roles, through: :users_roles do
    def active
      where("users_roles.deleted_at is null")
    end
  end

  has_many :users_groups
  has_many :groups, through: :users_groups do
    def active
      where("users_groups.deleted_at is null")
    end
  end

  scope :by_name, ->{ order(name: :asc) }

  def to_param() name end

  # validates :password, presence: true
  validates :email, presence: true
  validates :name, uniqueness: true, format: /[a-z0-9]+/

  def self.authenticate(name, password)
    u = User.find_by name: name
    return nil unless u
    u.authenticate password
  end

  def send_password_reset
    generate_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.forgot_password(self).deliver
  end

  def generate_token
    self.password_reset_token = SecureRandom.urlsafe_base64
  end

  def admin?
    roles.any? { |r| r.name == 'Site Admin' }
  end
end
