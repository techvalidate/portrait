class User < ActiveRecord::Base
  has_secure_password

  def self.authenticate(name, password)
    user = User.find_by name: name
    user.authenticate(password)
  end

  def self.generate_random_password
    Array.new(10).map { (65 + rand(58)).chr }.join
  end

  has_many :sites, dependent: :destroy

  def to_param() name end


  validates :password, presence: true
  validates :email, uniqueness:true, presence: true, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :name, uniqueness: true, presence: true, format: /[a-z0-9]+/
end
