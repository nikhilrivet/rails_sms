class GroupSmsController < ApplicationController
  def index
    @groups = Group.where(:user_id => current_user.id)
    @distributions = Distribution.where(:user_id => current_user.id)
  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:sender]
    message = params[:txtMessage]
    @togroups = params[:togroup]
    @todistributions = params[:todistribution]
    require 'net/http'


    uri = URI('http://66.42.104.90:1401/send')
    dlr_url = 'http://smpplive.com/delivery_receipt/get_dlr'
    user_name = current_user.username
    if params[:togroup]
      @togroups.each do |item|
        contacts = Contact.where(:group_id => item.to_i)

        contacts.each do |contact|
          params = { :username => user_name, :password => 'bar',
                     :to => contact.number, 'content' => message.encode("UTF-16BE"),:from => @sender ,
                     :coding => 8,
                     :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
          uri.query = URI.encode_www_form(params)

          @response = Net::HTTP.get_response(uri)
          @message_id = @response.body.from(9).to(-2)
          @message = Message.create(phone: contact.number, sender: @sender, message: message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id)
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
            params = { :username => user_name, :password => 'bar',
                       :to => dcontact.number, 'content' => message.encode("UTF-16BE"),:from => @sender ,
                       :coding => 8,
                       :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => dlr_url}
            uri.query = URI.encode_www_form(params)

            @response = Net::HTTP.get_response(uri)
            @message_id = @response.body.from(9).to(-2)
            @message = Message.create(phone: dcontact.number, sender: @sender, message: message, message_id: @message_id, message_status: 'PENDING', user_id: current_user.id)
          end
        end
      end
    end

    flash[:success] = "Success: Message sent successfully."
    redirect_to group_sms_index_path, locals: {response: @response}
  end
end
