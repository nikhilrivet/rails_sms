class SingleSmsController < ApplicationController
  def index
    
  end

  def send_sms
    @phone_number = params[:phone_number]
    require 'net/http'

    uri = URI('http://95.179.214.39:1401/send')
    params = { :username => 'foo', :password => 'bar',
               :to => '+971527088650', :content => 'Hello world',:from => 'Hanover MC' }
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)

    redirect_to single_sms_index_path, locals: {response: @response}
  end
end
