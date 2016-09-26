require 'rails_helper'

describe UsageTier, 'validations' do
  it 'should have a start value' do
    tier = UsageTier.new
    tier.valid?
    expect(tier.errors[:start]).not_to be_empty
  end

  it 'should have a price' do
    tier = UsageTier.new
    tier.valid?
    expect(tier.errors[:price_per]).not_to be_empty
  end

  it 'should have a number for start value' do
    tier = UsageTier.new(start: 'one')
    tier.valid?
    expect(tier.errors[:start]).not_to be_empty
  end

  it 'should have a number for price' do
    tier = UsageTier.new(price_per: 'two')
    tier.valid?
    expect(tier.errors[:price_per]).not_to be_empty
  end
end
