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
    if @schedule_date.empty?
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
    else
      @seconds_diff = (Time.parse(@schedule_date) - Time.parse(@current_date)).to_i.abs.to_s + "s"
      rest_url = URI(ENV['REST_API_HOST'] + "/secure/sendbatch")
      call_back_url = ENV['BATCH_CALLBACK_URL']
      http = Net::HTTP.new(rest_url.host, rest_url.port)
      request = Net::HTTP::Post.new(rest_url)
      request["Content-Type"] = 'application/json'
      request["Authorization"] = 'Basic ' + Base64.strict_encode64(user_name + ':' + jasmin_password)
      request["cache-control"] = 'no-cache'

      if params[:togroup]

        @togroups.each do |item|
          contacts = Contact.where(:group_id => item.to_i)

          contacts.each do |contact|
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
                          "to": [
                              contact.number
                          ],
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
                          "to": [
                              contact.number
                          ],
                          "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                      }
                  ]
              }.to_json
            end

            response = http.request(request)
            batch_data = JSON.parse(response.read_body)['data']
            unless batch_data['batchId'].nil?
              @message_str = "Success: Message sent successfully."
              @schedule = Schedule.create(phone: contact.number, sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, schedule_time: @schedule_date)
            else
              @message_str = "Fail: Message cannot send successfully."
            end
            flash[:message] = @message_str
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
                            "to": [
                                dcontact.number
                            ],
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
                            "to": [
                                dcontact.number
                            ],
                            "hex_content": @content.codepoints.map { |c| "%04X" % c }.join
                        }
                    ]
                }.to_json
              end


              response = http.request(request)
              batch_data = JSON.parse(response.read_body)['data']
              unless batch_data['batchId'].nil?
                @message_str = "Success: Message sent successfully."
                @schedule = Schedule.create(phone: dcontact.number, sender: @sender, message: message, batch_id: batch_data['batchId'], message_status: 'PENDING', user_id: current_user.id, schedule_time: @schedule_date)
              else
                @message_str = "Fail: Message cannot send successfully."
              end
            end
          end
        end
      end

      flash[:message] = @message_str
    end

    redirect_to group_sms_index_path, locals: {response: @response}
  end
end
