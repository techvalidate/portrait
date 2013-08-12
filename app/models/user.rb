class User < ActiveRecord::Base
  
  def self.authenticate(name, password)
    User.where(name: name, password: password).first
  end
  
  has_many :sites, :dependent=>:destroy
  
  def to_param() name end
  
  validates :password, presence: true
  validates :name, uniqueness: true, format: /[a-z0-9]+/
end
