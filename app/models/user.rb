class User < ActiveRecord::Base

  def self.authenticate(name, password)
    User.find_by name: name, password: password
  end

  belongs_to :customer
  has_many :sites, dependent: :destroy

  def to_param() name end

  validates :password, presence: true
  validates :name, uniqueness: true, format: /[a-z0-9]+/
  validates :customer, presence: true

  delegate :canceled?, to: :customer
end
