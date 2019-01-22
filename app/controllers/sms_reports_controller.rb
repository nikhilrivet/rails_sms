class SmsReportsController < ApplicationController
  def index
    @messages = Message.all
  end
end
