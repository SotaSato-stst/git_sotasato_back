Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  resources :subsidies, only: %i[index show]
  resources :companies, only: %i[index show create update]
  resources :ministries, only: %i[index]
  resources :prefectures, only: %i[index] do
    resources :cities, only: %i[index]
  end
  resources :business_categories, only: :index

  namespace :admin do
    resources :users, only: %i[index show create update]
  end
end
