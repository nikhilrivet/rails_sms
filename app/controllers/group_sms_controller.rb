class GroupSmsController < BaseController
  def index
    @groups = Group.where(:user_id => current_user.id)
    @distributions = Distribution.where(:user_id => current_user.id)
    @senders = Sender.where(:user_id => current_user.id)
  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:sender]
    message = params[:txtMessage]
    @togroups = params[:togroup]
    @todistributions = params[:todistribution]
    require 'net/http'

    if (message =~ /\p{Arabic}/).nil?
      @content = message
      @coding = 0
    else
      @content = message.encode("UTF-16BE")
      @coding = 8
    end

    uri = URI(ENV['HTTP_API_HOST'])
    dlr_url = ENV['DLR_URL']
    user_name = current_user.username
    jasmin_password = current_user.jasmin_password

    if params[:togroup]
      @togroups.each do |item|
        contacts = Contact.where(:group_id => item.to_i)

        contacts.each do |contact|
          params = { :username => user_name, :password => jasmin_password,
                     :to => contact.number, 'content' => @content,:from => @sender ,
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
          @message = Message.create(phone: contact.number, sender: @sender, message: message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id, message_send_status: message_send_status)
        end
      end
    end


    if params[:todistribution]
      
      @contact_numbers = Array.new()

      @todistributions.each do |item|
        dcontacts =Dcontact.where(:distribution_id => item.to_i)

        dcontacts.each do |dcontact|
          unless @contact_numbers.include? dcontact.number
            @contact_numbers.push(dcontact.number)
            params = { :username => user_name, :password => jasmin_password,
                       :to => dcontact.number, 'content' => @content,:from => @sender ,
                       :coding => @coding,
                       :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
            uri.query = URI.encode_www_form(params)

            @response = Net::HTTP.get_response(uri)
            @message_id = @response.body.from(9).to(-2)
            @message_status = @response.body.from(0).to(6)
            if @message_status == 'Success'
              message_send_status = 1
              @message_str = "Success: Message sent successfully."
            else
              message_send_status = 0
              @message_str = "Fail: Message cannot send successfully."
            end
            @message = Message.create(phone: dcontact.number, sender: @sender, message: message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id, message_send_status: message_send_status)
          end
        end
      end
    end

    flash[:success] = @message_str
    redirect_to group_sms_index_path, locals: {response: @response}
  end
end
