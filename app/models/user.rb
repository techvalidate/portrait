class User < ActiveRecord::Base
  
  def self.authenticate(name, password)
    User.find_by_name_and_password name, password
  end
  
  has_many :sites, :dependent=>:destroy
  
  default_scope :order=>'name'
  
  def to_param() name end
  
  validates_presence_of   :password
  validates_uniqueness_of :name
  validates_format_of     :name, :with=>/[a-z0-9]+/
  
end
