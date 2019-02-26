Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.

  devise_scope :user do
    authenticated :user do
      root :to => 'index#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :groups
  resources :senders
  resources :contacts
  resources :distributions
  resources :dcontacts

  get 'single_sms/index'
  get 'bulk_sms/index'
  get 'group_sms/index'
  get 'distribution_list/index'
  get 'credit_details/index'
  get 'today_stats/index'
  get 'sms_reports/index'
  get 'sms_reports/reports'
  get 'sms_summary/index'
  get 'acculync/index'
  get 'user_profile/index'
  get 'coverage_details/index'
  get 'telnet_connector/index'
  get 'schedule_reports/index'


  post 'single_sms/send_sms'
  post 'group_sms/send_sms'
  post 'user_profile/update'

  post 'delivery_receipt/get_dlr'
  get 'smpp/sendsms'
  post 'smpp/sendsms'
  get 'batch/call_back'

  namespace :admin do
    get 'index/index'

    resources :users
    resources :connectors
    resources :routers
    resources :filters
    root to: 'index#index'
  end

  namespace :reseller do
    get 'index/index'
    get 'single_sms/index'
    get 'bulk_sms/index'
    get 'group_sms/index'
    get 'distribution_list/index'
    get 'credit_details/index'
    get 'today_stats/index'
    get 'sms_reports/index'
    get 'sms_reports/reports'
    get 'sms_summary/index'
    get 'acculync/index'
    get 'user_profile/index'
    get 'coverage_details/index'
    get 'telnet_connector/index'

    post 'single_sms/send_sms'
    post 'group_sms/send_sms'
    post 'user_profile/update'

    resources :groups
    resources :senders
    resources :contacts
    resources :distributions
    resources :dcontacts
    resources :users
    resources :connectors
    resources :routers
    resources :filters
    root to: 'index#index'
  end

end
