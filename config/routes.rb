Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create, :index, :show]
  resources :friendships, only: [:create]
  get :find_experts, controller: :users
end
