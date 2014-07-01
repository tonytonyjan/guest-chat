namespace :room do
  desc "Destroy old rooms"
  task service: :environment do
    Room.where('updated_at < ?', 1.hour.ago).destroy_all
  end
end
