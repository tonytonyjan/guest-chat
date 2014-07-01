Rails.application.routes.draw do
  root 'rooms#create'
  resources :rooms, only: %i[create] do
    resources :messages, only: %i[index create]
  end
  get ':id' => 'rooms#show', as: :room
end
