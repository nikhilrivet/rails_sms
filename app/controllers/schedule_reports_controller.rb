class ScheduleReportsController < BaseController
  def index
    @batchs = Schedule.where(:user_id => current_user.id).order('id DESC')
  end
end
