Rails.application.routes.draw do
  get 'plain-turbo', to: 'plainturbo#index', as: :plain_turbo_example
  root to: 'home#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
