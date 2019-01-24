Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.

  devise_scope :user do
    authenticated :user do
      root :to => 'index#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'single_sms/index'
  get 'bulk_sms/index'
  get 'group_sms/index'
  get 'group_list/index'
  get 'distribution_list/index'
  get 'credit_details/index'
  get 'today_stats/index'
  get 'sms_reports/index'
  get 'sms_summary/index'
  get 'acculync/index'
  get 'user_profile/index'
  get 'coverage_details/index'
  get 'telnet_connector/index'

  post 'single_sms/send_sms'

  post 'delivery_receipt/get_dlr'
end
