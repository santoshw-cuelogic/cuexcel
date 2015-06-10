
worker_processes 5

APP_PATH =  Dir.pwd

working_directory APP_PATH

stderr_path APP_PATH + "/log/unicorn.stderr.log"
stdout_path APP_PATH + "/log/unicorn.stderr.log"

pid APP_PATH + "/tmp/pids/unicorn.pid"

listen APP_PATH + "/tmp/sockets/unicorn.sock", :backlog => 64
listen 3000, :tcp_nopush => true

timeout 300

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

end

after_fork do |server, worker|

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end


