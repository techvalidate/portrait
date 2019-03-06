class Customer < ApplicationRecord

  enum status: %i[cancelled active]

  has_many :users, dependent: :destroy

end
