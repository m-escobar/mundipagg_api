Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#index'

  get 'pages/index', as: 'index-pt'
  get 'pages/index-en', as: 'index-en'
  get 'pay', to: 'payment#index'
  get 'create_all_plans', to: 'payment#create_all_plans'
  get 'get_plans', to: 'payment#get_plans'
  get 'address', to: 'payment#create_address'
end
