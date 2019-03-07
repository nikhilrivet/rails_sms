class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_balance

  def current_balance
    used_count  = Message.where("message_send_status = :message_send_status and user_id = :user_id", { message_send_status: 1, user_id: current_user.id }).count
    current_count = current_user.sms_count - used_count
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end



  if :authenticate_user!
    "devise"
  else
    "application"
  end

end
