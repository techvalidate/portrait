class BillingScheme < ActiveRecord::Base
  has_one :customer, dependent: :destroy
  has_many :usage_tiers, dependent: :destroy

  validates :name, presence: true
  validates :usage_tiers, presence: true
end
