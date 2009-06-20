class Site < ActiveRecord::Base
  has_attached_file :image, :path => ':rails_root/public/sites/:id/:style/:basename.:extension',
                            :url  => '/sites/:id/:style/:basename.:extension'
                            
  acts_as_state_machine :initial=>:submitted
  state :submitted
  state :processing
  state :success
  state :failed
  
  event :process do
    transitions :from=>:submitted, :to=>:processing
  end
  
  event :succeeded do
    transitions :from=>:processing, :to=>:success
  end
  
  event :failed do
    transitions :from=>:processing, :to=>:failed
  end
  
  default_scope :order=>'created_at desc'
  
  validates_format_of :url, :with=>/^((http|https):\/\/)*[a-z0-9_-]{1,}\.*[a-z0-9_-]{1,}\.[a-z]{2,4}\/*$/i
  
end
