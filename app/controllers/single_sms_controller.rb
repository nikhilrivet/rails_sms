class SingleSmsController < ApplicationController
  def index

  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:sender]
    @message = params[:txtMessage]
    require 'net/http'
    content = "ازرع اسنانك بيوم واحد وبدون ألم مع ضمان مدى الحياة0551081988"

    uri = URI('http://66.42.104.90:1401/send')
    dlr_url = 'http://smpplive.com/delivery_receipt/get_dlr'
    user_name = current_user.username

    params = { :username => user_name, :password => 'bar',
               :to => @phone_number, 'content' => @message.encode("UTF-16BE"),:from => @sender ,
               :coding => 8,
               :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)
    @message_id = @response.body.from(9).to(-2)
    @message = Message.create(phone: @phone_number, sender: @sender, message: @message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id)
    flash[:message] = "Success: Message sent successfully."

    redirect_to single_sms_index_path, locals: {response: @response}
  end
end
