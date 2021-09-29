Rails.application.routes.draw do
  get 'repositories/index'
  get 'repositories/show'
  get 'pages/index'
  root to: 'pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
