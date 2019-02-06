class BaseController < ApplicationController

  before_action :verify_user
  def verify_user
    (current_user.nil?) ? redirect_to(unauthenticated_root_path) : (redirect_to(admin_root_path) if current_user.admin?)
  end

end
