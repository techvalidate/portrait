class Customer < ActiveRecord::Base
  has_many :users, dependent: :destroy

  validates :name, uniqueness: true, format: /[a-z0-9]+/

  def to_param() name end

  def active?
    !canceled?
  end

  def canceled?
    canceled_at.present?
  end

  def cancel!
    self.canceled_at = DateTime.current
    save
  end
end
