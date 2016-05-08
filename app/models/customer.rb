class Customer < ActiveRecord::Base
  validates_presence_of :name

  has_many :users, dependent: :destroy
  accepts_nested_attributes_for :users

  def all_users
    users.where(customer_id: self.id)
  end

  def all_admins
    users.where(customer_id: self.id, admin: true)
  end

end