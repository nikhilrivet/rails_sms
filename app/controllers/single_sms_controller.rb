class SingleSmsController < BaseController

  def index
    @senders = Sender.where(:user_id => current_user.id)
  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:sender]
    @message = params[:txtMessage]
    #@schedule_date = params[:schedule_date]
    @cmbMessageType = params[:cmbMessageType]
    puts @cmbMessageType
    if @cmbMessageType == '0'
      @content = @message
      @coding = 0
      puts @content
    end

    if @cmbMessageType == '1'
      @content = @message.encode("UTF-16BE")
      @coding = 8
    end

    require 'net/http'
    content = "ازرع اسنانك بيوم واحد وبدون ألم مع ضمان مدى الحياة0551081988"

    uri = URI(ENV['HTTP_API_HOST'])
    dlr_url = ENV['DLR_URL']
    user_name = current_user.username

    params = { :username => user_name, :password => 'bar',
               :to => @phone_number, 'content' => @content,:from => @sender ,
               :coding => @coding,
               :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)
    @message_status = @response.body.from(0).to(6)
    if @message_status == 'Success'
      message_send_status = 1
      @message_str = "Success: Message sent successfully."
    else
      message_send_status = 0
      @message_str = "Fail: Message cannot send successfully."
    end
    @message_id = @response.body.from(9).to(-2)
    @message = Message.create(phone: @phone_number, sender: @sender, message: @message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id, message_send_status: message_send_status)
    flash[:message] = @message_str

    redirect_to single_sms_index_path, locals: {response: @response}
  end
end
