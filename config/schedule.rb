set :output, '/home/rails/guest-chat/shared/log/cron.log'

every 2.hours do
  rake 'room:service'
end