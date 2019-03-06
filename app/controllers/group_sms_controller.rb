class GroupSmsController < BaseController
  def index
    @groups = Group.where(:user_id => current_user.id)
    @distributions = Distribution.where(:user_id => current_user.id)
    @senders = Sender.where(:user_id => current_user.id)
    @drafts = Draft.where(:user_id => current_user.id)
  end

  def send_sms

    require 'net/http'
    require 'json'
    require 'base64'
    require 'time'

    @phone_number = params[:phone_number]
    @sender = params[:sender]
    message = params[:txtMessage]
    @togroups = params[:togroup]
    @todistributions = params[:todistribution]
    @schedule_date = params[:schedule_date]
    @current_date = params[:current_date]

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

    rest_url = URI(ENV['REST_API_HOST'] + "/secure/sendbatch")
    call_back_url = ENV['BATCH_CALLBACK_URL']
    http = Net::HTTP.new(rest_url.host, rest_url.port)
    request = Net::HTTP::Post.new(rest_url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = 'Basic ' + Base64.strict_encode64(user_name + ':' + jasmin_password)
    request["cache-control"] = 'no-cache'

    if @schedule_date.empty?
      if params[:togroup]
        @contact_numbers = Array.new()
        @togroups.each do |item|
          contacts = Contact.where(:group_id => item.to_i)

          contacts.each do |contact|
            unless @contact_numbers.include? contact.number
              @contact_numbers.push(contact.number)
            end
          end
        end
        if @coding == 0
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "content": @content
                  }
              ]
          }.to_json
        else
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                  }
              ]
          }.to_json
        end


        response = http.request(request)
        batch_data = JSON.parse(response.read_body)['data']
        unless batch_data['batchId'].nil?
          @message_str = "Success: Message sent successfully."
          @schedule = Schedule.create(sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, message_count: batch_data['messageCount'])
        else
          @message_str = "Fail: Message cannot send successfully."
        end
      end


      if params[:todistribution]

        @contact_numbers = Array.new()

        @todistributions.each do |item|
          dcontacts =Dcontact.where(:distribution_id => item.to_i)

          dcontacts.each do |dcontact|
            unless @contact_numbers.include? dcontact.number
              @contact_numbers.push(dcontact.number)
            end
          end
        end
        if @coding == 0
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "content": @content
                  }
              ]
          }.to_json
        else
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                  }
              ]
          }.to_json
        end


        response = http.request(request)
        batch_data = JSON.parse(response.read_body)['data']
        unless batch_data['batchId'].nil?
          @message_str = "Success: Message sent successfully."
          @schedule = Schedule.create(sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, message_count: batch_data['messageCount'])
        else
          @message_str = "Fail: Message cannot send successfully."
        end
      end

      flash[:success] = @message_str
    else
      @seconds_diff = (Time.parse(@schedule_date) - Time.parse(@current_date)).to_i.abs.to_s + "s"

      if params[:togroup]
        @contact_numbers = Array.new()
        @togroups.each do |item|
          contacts = Contact.where(:group_id => item.to_i)

          contacts.each do |contact|
            unless @contact_numbers.include? contact.number
              @contact_numbers.push(contact.number)
            end
          end
        end

        if @coding == 0
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
                  "schedule_at": @seconds_diff
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "content": @content
                  }
              ]
          }.to_json
        else
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
                  "schedule_at": @seconds_diff
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                  }
              ]
          }.to_json
        end

        response = http.request(request)
        batch_data = JSON.parse(response.read_body)['data']
        unless batch_data['batchId'].nil?
          @message_str = "Success: Message sent successfully."
          @schedule = Schedule.create(sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, schedule_time: @schedule_date, message_count: batch_data['messageCount'])
        else
          @message_str = "Fail: Message cannot send successfully."
        end
        flash[:message] = @message_str
      end


      if params[:todistribution]

        @contact_numbers = Array.new()

        @todistributions.each do |item|
          dcontacts =Dcontact.where(:distribution_id => item.to_i)

          dcontacts.each do |dcontact|
            unless @contact_numbers.include? dcontact.number
              @contact_numbers.push(dcontact.number)
            end
          end
        end
        if @coding == 0
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
                  "schedule_at": @seconds_diff
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "content": @content
                  }
              ]
          }.to_json
        else
          request.body = {
              "batch_config": {
                  "callback_url": call_back_url,
                  "schedule_at": @seconds_diff
              },
              "globals": {
                  "from": @sender,
                  "dlr": "yes",
                  "dlr-url": dlr_url,
                  "dlr-level": 2,
                  "coding": @coding
              },
              "messages": [
                  {
                      "to": @contact_numbers,
                      "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                  }
              ]
          }.to_json
        end

        response = http.request(request)

        batch_data = JSON.parse(response.read_body)['data']
        unless batch_data['batchId'].nil?
          @message_str = "Success: Message sent successfully."
          @schedule = Schedule.create(sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, schedule_time: @schedule_date, message_count: batch_data['messageCount'])
        else
          @message_str = "Fail: Message cannot send successfully."
        end
      end

      flash[:message] = @message_str
    end

    redirect_to group_sms_index_path, locals: {response: @response}
  end
end
