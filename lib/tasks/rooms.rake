namespace :rooms do
  desc 'clean up unused rooms'
  task clean: :environment do
    Room.where('updated_at < ?', 1.day.ago).destroy_all
    Guest.where('updated_at < ?', 1.day.ago).destroy_all
  end
end
