Rails.application.routes.draw do
  root to: 'home#show'
  get 'plain-turbo', to: 'plainturbo#index', as: :plain_turbo_example
  get 'turbo-react', to: 'turboreact#index', as: :turbo_react_example
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
