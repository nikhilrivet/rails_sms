class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :verify_admin
  def verify_admin
    (current_user.nil?) ? redirect_to(unauthenticated_root_path) : (redirect_to(authenticated_root_path) unless current_user.admin?)
  end
end
