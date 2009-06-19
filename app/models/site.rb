class Site < ActiveRecord::Base
  has_attached_file :image, :path => ':rails_root/public/sites/:id/:style/:basename.:extension',
                            :url  => '/sites/:id/:style/:basename.:extension'
end
