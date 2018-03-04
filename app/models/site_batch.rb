class SiteBatch < ApplicationRecord
  belongs_to :user
  has_many :sites, dependent: :nullify

  enum status: %i[pending started completed]
  serialize :submitted_urls, Array

  after_create :pending!
  after_create :queue_batch_job

  private

  def queue_batch_job
    SiteBatchJob.perform_later self.id
  end

  def no_blank_urls
    return if submitted_urls.all?(&:present?)
    errors.add(:submitted_urls, "can't be blank")
  end

  validates_presence_of :user_id, :submitted_urls
  validate :no_blank_urls
end
