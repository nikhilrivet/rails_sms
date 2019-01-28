class SmsReportsController < ApplicationController
  def index
    @messages = Message.all.order('id DESC')
  end
end
