class SmsReportsController < BaseController
  require 'csv'

  def index
    #@messages = Message.where(:user_id => current_user.id, message_send_status: 1).order('id DESC')
    start = params[:iDisplayStart].present? ? params[:iDisplayStart] : 0
    length = params[:iDisplayLength].present? ? params[:iDisplayLength] : 1
    keyword = ''
    order_key = 'id'
    order_arrow = 'asc'
    if params[:sSearch].present?
      if params[:sSearch].present?
        keyword = params[:sSearch]
      end
    end

    if params[:sSortDir_0].present?
      order_arrow = params[:sSortDir_0]
    end

    if params[:iSortCol_0].present?
      case params[:iSortCol_0]
        when "0"
          order_key = "id"
        when "1"
          order_key = "message_id"
        when "2"
          order_key = "sender"
        when "3"
          order_key = "phone"
        when "4"
          order_key = "message"
        when "4"
          order_key = "created_at"
      end
    end

    keyword = keyword.gsub(/\s+/, " ").strip
    list_user = Message.where("(message_id LIKE '%#{keyword}%' OR sender LIKE '%#{keyword}%' OR phone LIKE '%#{keyword}%' OR message LIKE '%#{keyword}%') AND DATE(created_at) = '#{Date.today}'").order(order_key.to_s + " " + order_arrow.to_s).offset(start).limit(length)
    list_user = Message.where("DATE(created_at) = '#{Date.today}'") if keyword.nil?
    totalrecords = Message.where("(message_id LIKE '%#{keyword}%' OR sender LIKE '%#{keyword}%' OR phone LIKE '%#{keyword}%' OR message LIKE '%#{keyword}%') AND DATE(created_at) = '#{Date.today}'").count
    data = {}
    data[:sEcho] = 0
    data[:iTotalRecords] = totalrecords
    data[:iTotalDisplayRecords] = totalrecords
    data[:aaData] = []

    list_user.each_with_index do |user, index|
      data[:aaData] << ["#{start.to_i+index.to_i+1}", "#{user[:message_id]}", "#{user[:sender]}", "#{user[:phone]}", "#{user[:message]}", "#{user[:message_status ]}", "#{user[:created_at].strftime '%Y-%m-%d %H:%M:%S'}"]
    end

    respond_to do |format|
      format.html
      # format.json { render json: UserDatatable.new(view_context) }
      format.json { render json: data.to_json }
    end
  end

  def reports
    @results = Message.where(:user_id => current_user.id)
    respond_to do |format|
      format.html
      format.csv { send_data @results.to_csv }
    end
  end

end
