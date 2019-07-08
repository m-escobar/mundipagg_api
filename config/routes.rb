Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'payment#index'

  root to: 'pages#index'

  get 'pages/index', as: 'index-pt'
  get 'pages/index-en', as: 'index-en'
end
