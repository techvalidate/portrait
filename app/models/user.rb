class User < ApplicationRecord

  def self.authenticate(name, password)
    User.find_by name: name, password: password
  end

  has_secure_password

  has_many :sites, dependent: :destroy
  belongs_to :customer

  scope :by_name, ->{ order(name: :asc) }
  scope :by_name_for_customer, ->(customer) { where(customer: customer) }

  def to_param() name end

  validates :name, uniqueness: { scope: :customer }, format: /\A[a-z0-9]+\Z/ 
end
