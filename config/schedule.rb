set :output, '/home/rails/guest-chat/shared/log/cron.log'

every :hour do
  rake 'room:service log:clear'
end