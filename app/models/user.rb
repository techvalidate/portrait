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

  def site_count_for(start, finish)
    sites.within_dates(start, finish).count
  end

  def site_count_this_month
    start = DateTime.current.beginning_of_month

    site_count_for(start, start + 1.month)
  end

  def site_count_last_month
    finish = DateTime.current.beginning_of_month

    site_count_for(finish - 1.month, finish)
  end
end
