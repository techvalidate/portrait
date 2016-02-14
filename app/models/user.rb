class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # def self.authenticate(name, password)
  #  User.find_by name: name, password: password
  # end

  has_many :sites, dependent: :destroy

  def to_param() name end

  validates :name, uniqueness: true, format: /[a-z0-9]+/
end
