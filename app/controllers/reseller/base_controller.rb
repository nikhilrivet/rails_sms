class Reseller::BaseController < ApplicationController
  layout 'reseller'
  before_action :verify_reseller
  def verify_reseller
    (current_user.nil?) ? redirect_to(unauthenticated_root_path) : (redirect_to(authenticated_root_path) unless current_user.reseller?)
  end
end
