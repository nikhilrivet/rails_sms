
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
    require 'socket'
    require 'net/telnet'
    pop = Net::Telnet::new("Host" => "95.179.214.39",
                           "Timeout" => 50,
                           "Port" => 8990,
                           "Prompt" => /[$%#>] \z/n,
                           "telnetmode" =>true)

    pop.cmd("jcliadmin\njclipwd\nuser -a") { |c| print c }
    pop.cmd("username "+user_params[:username]) { |c| print c }
    pop.cmd("password bar") { |c| print c }
    pop.cmd("gid foogroup") { |c| print c }
    pop.cmd("uid "+user_params[:username]) { |c| print c }
    pop.cmd("mt_messaging_cred quota sms_count "+user_params[:sms_count]) { |c| print c }
    pop.cmd("ok\nquit") { |c| print c }
    pop.close
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
