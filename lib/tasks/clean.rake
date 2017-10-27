namespace :clean do
  task sites: :environment do
    Site.where('created_at < ?', 30.days.ago).find_each &:destroy
  end
end
