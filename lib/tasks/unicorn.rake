namespace :unicorn do
  desc "Unicorn restart"
  task :restart do
    system "kill -9 `cat ./tmp/pids/unicorn.pid`"
    system "bundle exec unicorn_rails -c ./unicorn.rb -E #{Rails.env} -D"
  end
end