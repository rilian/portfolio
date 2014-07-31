worker_processes ENV['UNICORN_WORKERS'] && ENV['UNICORN_WORKERS'].to_i || 2
timeout ENV['UNICORN_TIMEOUT'] && ENV['UNICORN_TIMEOUT'].to_i || 30
preload_app true

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen File.expand_path('../../tmp/sockets/unicorn.sock', __FILE__), backlog: 64
pid File.expand_path('../../tmp/pids/unicorn.pid', __FILE__)

# Set the path of the log files inside the log folder of the testapp
stderr_path File.expand_path('../../log/unicorn.stderr.log', __FILE__)
stdout_path File.expand_path('../../log/unicorn.stdout.log', __FILE__)

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
