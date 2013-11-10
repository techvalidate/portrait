class User < ActiveRecord::Base
  has_many :sites, :dependent=>:destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.authenticate(name, password)
    User.where(name: name, password: password).first
  end
end
