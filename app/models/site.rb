class Site < ActiveRecord::Base
  # the "ultimate" url regex according to https://mathiasbynens.be/demo/url-regex
  # with slight modifications
  URL_REGEX = /\A(?:(?:https?):\/\/)(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/
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
    command = "phantomjs --ignore-ssl-errors=true #{Rails.root}/lib/rasterize.js #{url} #{Rails.root}/tmp/#{id}-full.png"
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
  validates :user, presence: true
  validates :url, presence: true, format: URL_REGEX

  #############################################################################
  #                               S C O P E S                                 #
  #############################################################################
  default_scope { order(created_at: :desc) }

end
