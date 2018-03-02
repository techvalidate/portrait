class SiteBatch < ApplicationRecord
  belongs_to :user
  has_many :sites

  enum status: %i[pending started completed]
  serialize :submitted_urls, Array

  validates_presence_of :user_id, :submitted_urls, :status

  after_initialize :pending!
  after_create :queue_batch_job


  private

  def queue_batch_job

  end
end
