Rails.application.routes.draw do
  root 'rooms#create'
  get ':id' => 'rooms#show', as: :room
end
