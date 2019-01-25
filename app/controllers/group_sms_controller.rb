class GroupSmsController < ApplicationController
  def index
    @groups = Group.where(:user_id => current_user.id)
  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:sender]
    message = params[:txtMessage]
    @togroups = params[:togroup]

    require 'net/http'


    uri = URI('http://95.179.214.39:1401/send')
    dlr_url = 'https://rivetsms.herokuapp.com/delivery_receipt/get_dlr'

    @togroups.each do |item|
      contacts = Contact.where(:group_id => item.to_i)

      contacts.each do |contact|
        params = { :username => 'foo', :password => 'bar',
                   :to => contact.number, 'content' => message.encode("UTF-16BE"),:from => @sender ,
                   :coding => 8,
                   :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
        uri.query = URI.encode_www_form(params)

        @response = Net::HTTP.get_response(uri)
        @message_id = @response.body.from(9).to(-2)
        @message = Message.create(phone: contact.number, sender: @sender, message: message, message_id: @message_id, message_status: 'PENDING')
      end
    end
    flash[:message] = "Success: Message sent successfully."
    redirect_to group_sms_index_path, locals: {response: @response}
  end
end
