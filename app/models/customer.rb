class Customer < ActiveRecord::Base
  has_many :users, :dependent=>:destroy

  validates :name, uniqueness: true

  def to_param() name end

  def update_request_count
    update_attribute(:request_count, request_count + 1)
  end
end
