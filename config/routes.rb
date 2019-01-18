Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.
  root 'index#index'

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

  get 'single_sms/send_sms'
end
