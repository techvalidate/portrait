class Customer < ApplicationRecord

  # TODO It is dumb to have a status enum with only 2 values. This will be more useful when pricing gets added.
  enum status: %i[cancelled active]

  has_many :users, dependent: :destroy
  has_many :sites, through: :users

  accepts_nested_attributes_for :users

  validates :name, uniqueness: true, format: /\A[A-Za-z0-9\s]+\Z/ 
end
