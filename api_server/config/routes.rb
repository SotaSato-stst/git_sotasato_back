Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  resources :subsidies, only: %i[index show]
  resources :ministries, only: %i[index]
  resources :user_favorite_subsidies, only: %i[index create destroy]
  resources :prefectures, only: %i[index] do
    resources :cities, only: %i[index]
  end
  resources :business_categories, only: :index

  namespace :admin do
    resources :companies, only: %i[index show create update]
    resources :users, only: %i[index show create update]
    resources :subsidies, only: %i[create]
    resources :subsidy_drafts, only: %i[index show]
  end
end
