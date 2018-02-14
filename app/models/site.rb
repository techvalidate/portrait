class Site < ApplicationRecord
  #############################################################################
  #                               P A P E R C L I P                           #
  #############################################################################
  has_attached_file :image

  validates_attachment :image,
    content_type: { content_type: /\Aimage\/.*\Z/ },
    file_name: { matches: [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/] }

  #############################################################################
  #                           S T A T E    M A C H I N E                      #
  #############################################################################
  enum status: %i[submitted started succeeded failed]

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
    handle generate_png
  end

  # Generate png and returns path
  # RIP webkit2png: # command = "python #{Rails.root}/lib/webkit2png --transparent -F -o #{id} -D #{Rails.root}/tmp #{url} "
  def generate_png
    node      = `which node`.chomp
    file_name = "#{id}-full.png"
    command   = "#{node} #{Rails.root}/app/javascript/puppeteer/generate_screenshot.js --url='#{url}' --fullPage=true --omitBackground=true --savePath='#{Rails.root}/tmp/' --fileName='#{file_name}' --no-sandbox"

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
