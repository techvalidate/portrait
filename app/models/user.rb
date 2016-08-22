class User < ActiveRecord::Base

  has_secure_password

  has_many :sites, dependent: :destroy

  def to_param() name end

  validates :name, uniqueness: true, format: /[a-z0-9]+/
end
