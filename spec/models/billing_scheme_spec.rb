require 'rails_helper'

describe BillingScheme, 'validations' do
  it 'should have a name' do
    billing = BillingScheme.new
    billing.valid?
    expect(billing.errors[:name]).not_to be_empty
  end

  it 'should not have zero tiers' do
    billing = BillingScheme.create(name: 'no tiers', usage_tiers: [])

    expect(billing.errors[:usage_tiers]).not_to be_empty
  end
end

describe BillingScheme, 'associations' do
  it 'can have many tiers' do
    tiers = %i(lower middle upper).map { |t| usage_tiers(t) }
    billing = BillingScheme.create(name: '3 tiers', usage_tiers: tiers)

    expect(billing.errors[:usage_tiers]).to be_empty
    expect(billing.usage_tiers.count).to eq(tiers.count)
  end

  it 'should remove tiers on billing scheme removal' do
    tiers = %i(lower middle upper).map { |t| usage_tiers(t) }
    billing = BillingScheme.create(name: '1 tier', usage_tiers: tiers)

    expect { billing.destroy }.to change{UsageTier.count}.from(tiers.count).to(0)
  end
end