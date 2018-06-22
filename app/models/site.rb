class Site < ActiveRecord::Base
  #############################################################################
  #                               P A P E R C L I P                           #
  #############################################################################
  has_attached_file :image

  SUPPORTED_FORMATS = %w(png pdf)
  validates :format, inclusion: { in: SUPPORTED_FORMATS }

  validates_attachment :image,
    content_type: { content_type: [/\Aimage\/.*\Z/, 'application/pdf'] },
    file_name: { matches: [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/, /pdf\Z/] }

  #############################################################################
  #                           S T A T E    M A C H I N E                      #
  #############################################################################
  enum status: [:submitted, :started, :succeeded, :failed]

  #############################################################################
  #                         R E L A T I O N S H I P S                         #
  #############################################################################
  belongs_to :user, counter_cache: true

  #############################################################################
  #                                   X M L                                   #
  #############################################################################
  # Used as an attribute in xml result - See SitesController#api
  def image_url
    image.url.split('?').first if image.present?
  end

  #############################################################################
  #                             P R O C E S S I N G                           #
  #############################################################################
  after_create :process!
  def process!
    started!
    handle puppeteer
  end

  def puppeteer
    node      = `which node`.chomp
    file_name = "#{id}.#{format}"
    command   = "#{node} #{Rails.root}/app/javascript/puppeteer/generate_#{format}.js --url='#{url}' --savePath='#{Rails.root}/tmp/' --fileName='#{file_name}' --selector='#{selector}'"
    system command
    return "#{Rails.root}/tmp/#{file_name}"
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
