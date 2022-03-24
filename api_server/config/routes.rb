Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'

  # 共用API
  resources :ministries, only: %i[index]
  resources :prefectures, only: %i[index] do
    resources :cities, only: %i[index]
  end

  # 補助金ドックの企業向けAPI
  scope module: 'business' do
    resources :subsidies, only: %i[index show] do
      member do
        get :preview
      end
    end
    resources :ranking_subsidies, only: %i[index]
    resources :user_favorite_subsidies, only: %i[index create destroy]
    resources :business_categories, only: :index
    resources :organization_types, only: :index
    resource :current_user, only: %i[show update]
    resources :user_email_unsubscribes, only: %i[index create destroy], param: :email_category
  end

  # 管理画面向けAPI
  namespace :admin do
    resources :companies, only: %i[index show create update]
    resources :users, only: %i[index show create update]
    resources :subsidies, only: %i[index show create update]
    resources :subsidy_drafts, only: %i[index show update]
    resources :subsidy_drafts_assignees, only: %i[index update destroy], param: :assignee_id
    resources :top_keywords, only: :index
    resources :searched_keywords, only: :index
    get :new_subsidy, to: 'new_subsidy#show'
  end

  # Schedule(cron)向けAPI
  namespace :tasks do
    get :new_subsidy, to: 'new_subsidy#show'
    get :new_subsidy_emails, to: 'new_subsidy_emails#show'
    get :report_subsidy_stats, to: 'report_subsidy_stats#show'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
