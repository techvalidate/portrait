class UsersGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  scope :active, -> { where('deleted_at is null') }
  scope :inactive, -> { where('deleted_at is not null') }
end
