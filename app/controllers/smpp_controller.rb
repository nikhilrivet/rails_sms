class SmppController < ApplicationController
  skip_before_action :verify_authenticity_token
  def sendsms
    @phone_number = params[:to]
    @username = params[:username]
    @password = params[:password]
    @sender = params[:from]

    @user = User.where(:username => @username, :jasmin_password => @password).first
    if @user.nil?
        return_msg = 'Error: 1029 - "Authentication failure for userinfo"'
      render :json => return_msg
      return
    end

    @message = params[:content]

    if (@message =~ /\p{Arabic}/).nil?
      @content = @message
      @coding = 0
    else
      @content = @message.encode("UTF-16BE")
      @coding = 8
    end

    require 'net/http'

    uri = URI(ENV['HTTP_API_HOST'])
    dlr_url = ENV['DLR_URL']
    user_name = @username
    jasmin_password = @password

    params = { :username => user_name, :password => jasmin_password,
               :to => @phone_number, 'content' => @content,:from => @sender ,
               :coding => @coding,
               :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)
    @message_status = @response.body.from(0).to(6)
    if @message_status == 'Success'
      message_send_status = 1
    else
      message_send_status = 0
    end
    @message_id = @response.body.from(9).to(-2)
    @message = Message.create(phone: @phone_number, sender: @sender, message: @message, message_id: @message_id, message_status: 'PENDING', user_id: @user.id, message_send_status: message_send_status)

    render :json => @response.body
  end
end
