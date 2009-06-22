class User < ActiveRecord::Base
  
  def self.authenticate(name, password)
    User.find_by_name_and_password name, password
  end
  
  has_many :sites
  
  validates_presence_of   :name, :password
  validates_uniqueness_of :name
  
end
