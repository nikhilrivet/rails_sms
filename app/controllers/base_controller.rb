class BaseController < ApplicationController

  before_action :verify_user
  helper_method :current_balance
  def verify_user
    if current_user.nil?
      redirect_to(unauthenticated_root_path)
      return
    end
    if current_user.admin?
      redirect_to(admin_root_path)
      return
    end
    if current_user.reseller?
      redirect_to(reseller_root_path)
      return
    end
=begin
    (current_user.nil?) ? redirect_to(unauthenticated_root_path) : (redirect_to(admin_root_path) if current_user.admin?) : (redirect_to(reseller_root_path) if current_user.reseller?)
=end
  end

  def current_balance
    used_count  = Message.where("message_send_status = :message_send_status and user_id = :user_id", { message_send_status: 1, user_id: current_user.id }).count
    current_count = current_user.sms_count - used_count
  end

end
