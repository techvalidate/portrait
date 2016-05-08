class User < ActiveRecord::Base

  has_secure_password
  attr_accessor :skip_password_validation

  has_many :sites, dependent: :destroy
  belongs_to :customer

  before_destroy :check_last_admin

  scope :per_customer, -> (customer_id) { where(customer_id: customer_id)}
  scope :exclude_user, -> (user_id) { where('id is not ?', user_id)}

  def to_param() name end

  validates_presence_of :password_digest
  validates_presence_of :password, unless: :skip_password_validation
  validates_presence_of :password_confirmation, unless: :skip_password_validation
  validates :name, format: /[a-zA-Z0-9]+/
  validates :email, uniqueness: true, format: /.+@.+\..+/
  validate :name_uniqueness, :one_admin_minimum

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def skip_password_validation
    @skip_password_validation ||= false
  end

  private
  def check_last_admin
    unless self.customer.all_admins.count > 1
      errors.add(:admin, "before you delete this user, select a different one to become an admin.")
    end
  end

  def name_uniqueness
    unless unique_name?
      errors.add(:name, 'has already beed taken')
    end
  end

  def unique_name?
    other_users = User.per_customer(self.customer_id).exclude_user(self.id)
    other_users.pluck(:name).exclude? self.name
  end

  def one_admin_minimum
    unless self.admin? && enough_admins?
      errors.add(:admin, 'need to be set for at least one user.')
    end
  end

  def enough_admins?
    self.customer.all_admins.count > 0
  end

  def check_password
    if admin? && password_unchanged?
      password_confirm = password
    end
  end

  def password_unchanged?
    password_digest == password
  end

end
