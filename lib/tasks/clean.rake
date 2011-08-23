namespace :clean do
  task :sites=>:environment do
    Site.find(:all, :conditions=>['created_at < ?', 30.days.ago]).each &:destroy
  end
end