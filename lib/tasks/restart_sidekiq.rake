desc "Restart Application"
task :restart_sidekiq => :environment do
  puts "Rails environment is: #{Rails.env}"

  puts "stopping sidekiq"
  system "sidekiqctl stop 'tmp/pids/sidekiq.pid' 60"

  puts "starting sidekiq"
  system "bundle exec sidekiq -C #{File.join(Rails.root,'config/sidekiq.yml')} \
          -L #{File.join(Rails.root,'log/sidekiq.log')} \
          -P #{File.join(Rails.root,'tmp/pids/sidekiq.pid')} -d"

  if $?.exitstatus == 0
    puts "complete - Sidekiq Restarted"
  else
    puts "There were errors that prevented Sidekiq to restart"
  end
end