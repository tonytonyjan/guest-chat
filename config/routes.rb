Rails.application.routes.draw do
  root 'rooms#create'
  resources :rooms, only: :create do
    resources :messages, only: %i[index create]
  end
  get ':id' => 'rooms#show', as: :room
end
