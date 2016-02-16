class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sites, dependent: :destroy

  def to_param() name end

  validates :name, presence: true, uniqueness: {case_sensitive: false}, format: /\A[a-z0-9]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false},
            format: Devise.email_regexp

  # Devise hack to switch out default email as username
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
