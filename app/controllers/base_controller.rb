class BaseController < ApplicationController

  before_action :verify_user
  def verify_user
    if current_user.nil?
      redirect_to(unauthenticated_root_path)
    end
    if current_user.admin?
      redirect_to(admin_root_path)
    end
    if current_user.reseller?
      redirect_to(reseller_root_path)
    end
=begin
    (current_user.nil?) ? redirect_to(unauthenticated_root_path) : (redirect_to(admin_root_path) if current_user.admin?) : (redirect_to(reseller_root_path) if current_user.reseller?)
=end
  end

end
