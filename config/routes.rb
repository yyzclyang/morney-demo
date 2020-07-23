Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :users
  # 等价于
  # get '/users', to: 'users#index'
  # get '/users/:id', to: 'users#show'
  # post '/users', to: 'users#create'
  # delete '/users/:id', to: 'users#destroy'
  # patch '/users/:id', to: 'users#update'

  resource :sessions, only: [:create]
  delete '/sessions', to: 'sessions#destroy'
end
