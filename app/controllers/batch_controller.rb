class BatchController < ApplicationController
  skip_before_action :verify_authenticity_token
  def call_back
    @batch_id = params[:batchId]
    @phone_number = params[:to]
    @state = params[:status]
    @status_text = params[:statusText]

    schedule = Schedule.find_by_batch_id(@batch_id)
    if @state == "1"
      schedule.message_status = "SENT"
    end
    schedule.save

    @message_status = @status_text.from(0).to(6)
    if @message_status == 'Success'
      message_send_status = 1
      @message_str = "Success: Message sent successfully."
    else
      message_send_status = 0
      @message_str = "Fail: Message cannot send successfully."
    end
    @message_id = @status_text.from(9).to(-2)
    @message = Message.create(phone: @phone_number, sender: schedule.sender, message: schedule.message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id, message_send_status: message_send_status)

    data = "ACK/Jasmin"
    render :json => data
  end
end
