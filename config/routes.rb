Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Index with info
  root to: 'pages#index'

  get 'pages/index', as: 'index-pt'
  get 'pages/index-en', as: 'index-en'

  #for testing only
  get 'create_plans', to: 'testing#create_plans'
  get 'get_plans', to: 'testing#get_plans'
  
  get 'customer', to: 'customer#main'
  get 'pay', to: 'payment#main'
end
