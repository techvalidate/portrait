class Site < ActiveRecord::Base
  #############################################################################
  #                               P A P E R C L I P                           #
  #############################################################################
  has_attached_file :image, path: ':rails_root/public/sites/:id/:style/:basename.:extension',
                            url:  '/sites/:id/:style/:basename.:extension'

  validates_attachment_file_name :image, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]

  #############################################################################
  #                           S T A T E    M A C H I N E                      #
  #############################################################################
  enum status: [:submitted, :started, :succeeded, :failed]

  #############################################################################
  #                         R E L A T I O N S H I P S                         #
  #############################################################################
  belongs_to :user, counter_cache: true

  #############################################################################
  #                                 S C O P E S                               #
  #############################################################################
  scope :for_customer, -> (id) { joins(:user).where("users.customer_id= ?", id) }

  #############################################################################
  #                                   X M L                                   #
  #############################################################################
  # Used as an attribute in xml result - See SitesController#api
  def image_url
    image.url.split('?').first if image
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
    command = "python #{Rails.root}/lib/webkit2png --transparent -F -o #{id} -D #{Rails.root}/tmp #{url} "
    system command
    return "#{Rails.root}/tmp/#{id}-full.png"
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
  #                               V A L I D A T I O N                         #
  #############################################################################
  validates :user_id, presence: true
  validates :url, format: /\A((http|https):\/\/)*[a-z0-9_-]{1,}\.*[a-z0-9_-]{1,}\.[a-z]{2,5}(\/)?\S*\z/i

end
