class Site < ActiveRecord::Base
  #############################################################################
  #                               P A P E R C L I P                           #
  #############################################################################
  has_attached_file :image, :path => ':rails_root/public/sites/:id/:style/:basename.:extension',
                            :url  => '/sites/:id/:style/:basename.:extension'
  
  #############################################################################
  #                           S T A T E    M A C H I N E                      #
  #############################################################################           
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
  
  #############################################################################
  #                                       X M L                               #
  #############################################################################
  def image_url
    image.try :url
  end
  
  def to_xml
    xml = Builder::XmlMarkup.new :indent=>2
    xml.site do
      xml.state state
      xml.image_url image_url
    end
  end
  
  #############################################################################
  #                             P R O C E S S I N G                           #
  #############################################################################
  after_create 'process!'
  def process!
    started!
    handle generate_png
  end
  
  # Generate png and returns path
  def generate_png
    command = "python #{Rails.root}/lib/webkit2png -F -o #{id} -D #{Rails.root}/tmp #{url} "
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

  #############################################################################
  #                                  S C O P I N G                            #
  #############################################################################
  default_scope :order=>'created_at desc'
  
  #############################################################################
  #                               V A L I D A T I O N                         #
  #############################################################################
  validates_format_of :url, :with=>/^((http|https):\/\/)*[a-z0-9_-]{1,}\.*[a-z0-9_-]{1,}\.[a-z]{2,4}\/*$/i
  
end
