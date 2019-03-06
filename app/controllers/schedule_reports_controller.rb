class ScheduleReportsController < BaseController
  def index
    @batchs = Schedule.where(:user_id => current_user.id).where.not(schedule_time: [nil, ""]).order('id DESC')
  end
end
