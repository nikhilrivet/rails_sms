class SingleSmsController < ApplicationController
  def index
    
  end

  def send_sms
    @phone_number = params[:phone_number]
    @sender = params[:phone_number]
    @message = params[:message]
    require 'net/http'

    uri = URI('http://95.179.214.39:1401/send')
    params = { :username => 'foo', :password => 'bar',
               :to => @phone_number, :content => @message,:from => @sender ,
               :dlr => 'yes', 'dlr-level' => 2, 'dlr-url' => 'http://217.69.4.126/dlr.php'}
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)

    redirect_to single_sms_index_path, locals: {response: @response}
  end
end
