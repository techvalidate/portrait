class Site < ActiveRecord::Base
  has_attached_file :image, :path => ':rails_root/public/sites/:id/:style/:basename.:extension',
                            :url  => '/sites/:id/:style/:basename.:extension'
                            
  acts_as_state_machine :initial=>:submitted
  state :submitted
  state :processing
  state :success
  state :failed
  
  event :started do
    transitions :from=>:submitted, :to=>:processing
  end
  
  event :succeeded do
    transitions :from=>:processing, :to=>:success
  end
  
  event :failed do
    transitions :from=>:processing, :to=>:failed
  end
  
  after_create 'process!'
  def process!
    started!
    handle generate_png
  end
  
  # Generate png and returns path
  def generate_png
    command = "python #{Rails.root}/lib/webkit2png -F -o #{id} -D #{Rails.root}/tmp --delay=2 #{url} "
    logger.info "Executing #{command}"
    system command
    "#{Rails.root}/tmp/#{id}-full.png"
  end
  
  # Set the png located at path to the image
  def handle(path)
    File.exist?(path) ? attach(path) : failed!
  end
  
  def attach(path)
    file = File.open path
    update_attribute :image, file
    file.close
    succeeded!
  ensure
    FileUtils.rm path
  end

  
  default_scope :order=>'created_at desc'
  
  validates_format_of :url, :with=>/^((http|https):\/\/)*[a-z0-9_-]{1,}\.*[a-z0-9_-]{1,}\.[a-z]{2,4}\/*$/i
  
end
