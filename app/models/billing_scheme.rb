class BillingScheme < ActiveRecord::Base
  has_one :customer, dependent: :destroy
  has_many :usage_tiers, dependent: :destroy

  validates :name, presence: true
  validates :usage_tiers, presence: true

  def owed_for(count)
    total = 0
    usage_tiers.order(:start).each_with_index do |tier, index|
      tier_count = count
      if index + 1 < usage_tiers.count
        cap = usage_tiers[index + 1].start - tier.start
        tier_count = [tier_count, cap].min
      end
      total += tier.price_per * tier_count
      count -= tier_count
    end

    total
  end
end
