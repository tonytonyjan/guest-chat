Rails.application.routes.draw do
  root 'rooms#create'
  resources :rooms, only: %i[show create] do
    resources :messages, only: %i[index create]
  end
end
