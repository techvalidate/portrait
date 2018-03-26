class Role < ApplicationRecord
  has_many :users_roles, dependent: :destroy
  has_many :users, through: :users_roles do
    def active
      where("users_roles.deleted_at is null")
    end
  end

  validates :name, presence: true, uniqueness: true
end
