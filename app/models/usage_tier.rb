class UsageTier < ActiveRecord::Base
  belongs_to :billing_scheme

  validates :start, numericality: true
  validates :price_per, numericality: true
end
