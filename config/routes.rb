Rails.application.routes.draw do

  root to: 'pages#index'

  get 'pages/index', as: 'index-pt'
  get 'pages/index-en', as: 'index-en'
end
