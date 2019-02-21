
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
    @user = User.new(:username => user_params[:username], :email => user_params[:email], :sms_count => user_params[:sms_count], :role => user_params[:role], :password =>'12345678', :password_confirmation => '12345678', :jasmin_password => '12345678')
    jasmin_user = JasminUser.new()
    unless jasmin_user.add_user(user_params[:username], '12345678', user_params[:sms_count])
      render 'new'
    end

    if @user.save
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    jasmin_user = JasminUser.new()
    unless jasmin_user.update_user(@user.username, user_params[:sms_count])
      render 'new'
    end
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, :notice => "User updated."
    else
      redirect_to admin_users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    @user = User.find(params[:id])
    jasmin_user = JasminUser.new()
    unless jasmin_user.delete_user(@user.username)
      redirect_to admin_users_path, :notice => "Unable to delete user."
      return
    end
    @user.destroy
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
