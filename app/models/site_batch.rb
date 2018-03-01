class SiteBatch < ApplicationRecord
  belongs_to :user
  has_many :sites

  enum status: %i[pending started completed]

  validates_presence_of :user_id
end
