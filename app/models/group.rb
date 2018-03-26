class Group < ApplicationRecord
  has_many :users_groups, dependent: :destroy
  has_many :users, through: :users_groups do
    def active
      where("users_groups.deleted_at is null")
    end
  end

  validates :name, presence: true, uniqueness: true
end
