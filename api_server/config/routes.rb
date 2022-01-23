Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  resources :subsidies, only: %i[index show]
  resources :companies, only: %i[index show]
  resources :ministries, only: %i[index]
  resources :prefectures, only: %i[index] do
    resources :cities, only: %i[index]
  end
end
