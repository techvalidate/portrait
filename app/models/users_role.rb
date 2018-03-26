class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  def remove
    self.deleted_at = Time.new
  end
end
