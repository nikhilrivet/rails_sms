class Reseller::SmsReportsController < Reseller::BaseController
  require 'csv'

  def index
    @messages = Message.where(:user_id => current_user.id, message_send_status: 1).order('id DESC')
  end

  def reports
    @results = Message.where(:user_id => current_user.id)
    respond_to do |format|
      format.html
      format.csv { send_data @results.to_csv }
    end
  end

end
