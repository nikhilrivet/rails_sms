class DeliveryReceiptController < ApplicationController
  skip_before_action :verify_authenticity_token
  def get_dlr
    @message_status = params[:message_status]
    @donedate = params[:donedate]
    @sub = params[:sub]
    @err = params[:err]
    @level = params[:level]
    @text = params[:text]
    @id_smsc = params[:id_smsc]
    @dlvrd = params[:dlvrd]
    @subdate = params[:subdate]
    @msg_id = params[:id]

    message = Message.find_by_message_id(@msg_id)
    message.message_status = @message_status
    message.donedate = @donedate
    message.sub = @sub
    message.err = @err
    message.level = @level
    message.text = @text
    message.id_smsc = @id_smsc
    message.dlvrd = @dlvrd
    message.subdate = @subdate
    message.save

    data = "ACK/Jasmin"
    render :json => data
  end
end
