Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  resources :subsidies, only: %i[index show]
end
