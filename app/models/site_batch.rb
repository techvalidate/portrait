class SiteBatch < ApplicationRecord
  belongs_to :user
  has_many :sites

  enum status: %i[pending started completed]
  serialize :submitted_urls, Array

  validates_presence_of :user_id, :submitted_urls

  after_create :pending!
  after_create :queue_batch_job


  private

  def queue_batch_job
    SiteBatchJob.perform_later self.id
  end
end
