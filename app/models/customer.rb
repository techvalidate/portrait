class Customer < ActiveRecord::Base
  belongs_to :billing_scheme
  has_many :users, dependent: :destroy

  after_initialize :init

  validates :billing_scheme, presence: true
  validates :name, uniqueness: true, format: /[a-z0-9]+/

  def init
    self.balance ||= 0.0
  end

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

  def sum_for(symbol)
    users.map { |u| u.send(symbol) }.inject(0, :+)
  end

  def site_count_this_month
    sum_for(:site_count_this_month)
  end

  def site_count_last_month
    sum_for(:site_count_last_month)
  end

  def owed_this_month
    billing_scheme.owed_for site_count_this_month
  end

  def owed_last_month
    billing_scheme.owed_for site_count_last_month
  end

  def bill_last_month!
    self.balance += owed_last_month
    save
  end

  def self.sum_for(symbol)
    self.all.map { |c| c.send(symbol) }.inject(0, :+)
  end

  def self.site_count_this_month
    sum_for(:site_count_this_month)
  end

  def self.site_count_last_month
    sum_for(:site_count_last_month)
  end

  def self.owed_this_month
    sum_for(:owed_this_month)
  end

  def self.owed_last_month
    sum_for(:owed_last_month)
  end

  def self.balance
    sum_for(:balance)
  end
end
