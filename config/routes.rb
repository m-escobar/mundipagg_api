Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Index with info
  root to: 'pages#index'

  get 'pages/index', as: 'index-pt'
  get 'pages/index-en', as: 'index-en'

  #for testing only
  get 'create_plans', to: 'demos#create_plans'
  get 'get_plans', to: 'demos#get_plans'
  
  get 'customers', to: 'customers#main'
  get 'pay', to: 'payment#main'
end
