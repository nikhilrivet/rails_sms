class IndexController < BaseController
  before_action :authenticate_user!
  def index
    @total_purchased = current_user.sms_count
    @sms_used = used_count  = Message.where("message_send_status = :message_send_status and user_id = :user_id", { message_send_status: 1, user_id: current_user.id }).count
    @current_balance = @total_purchased - @sms_used
  end
end
