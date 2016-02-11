class User < ActiveRecord::Base
  # Include devise modules. Others available are:
  # :rememberable, :trackable, :validatable, :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable
  
  def self.authenticate(name, password)
    user = User.where(name: name).first
    (user && user.valid_password?(password)) ? user : nil
  end

  belongs_to :customer
  has_many :sites, :dependent=>:destroy

  def to_param() name end
  
  validates :password, presence: true
  validates :name, uniqueness: true, format: /[a-z0-9]+/

  def update_request_count
    customer.try(:update_request_count)
  end
end
