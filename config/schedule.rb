set :output, '/home/rails/guest-chat/shared/log/cron.log'
env :PATH, ENV['PATH']
every :hour do
  rake 'room:service'
end