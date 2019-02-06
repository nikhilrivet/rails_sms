
class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    jasmin_user = JasminUser.new()
    jasmin_user.add_user(user_params[:username], user_params[:username], user_params[:sms_count])
    @user = User.new(:username => user_params[:username], :email => user_params[:email], :sms_count => user_params[:sms_count], :role => user_params[:role], :password =>'123456789', :password_confirmation => '123456789')
    if @user.save
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, :notice => "User updated."
    else
      redirect_to admin_users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path, :notice => "User deleted."
  end

  private

  def user_params
    params.require(:user).permit(
        :username,
        :email,
        :sms_count,
        :role,
    )
  end
end
