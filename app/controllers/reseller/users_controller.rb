
class Reseller::UsersController < Reseller::BaseController
  def index
    @users = User.where(parent_id: current_user.id)
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
    @user = User.new(:username => user_params[:username], :email => user_params[:email], :sms_count => user_params[:sms_count], :role => 0, :password =>user_params[:password], :password_confirmation => user_params[:password], :jasmin_password => user_params[:password], :parent_id => current_user.id)
    jasmin_user = JasminUser.new()
    unless jasmin_user.add_user(user_params[:username], user_params[:password], user_params[:sms_count])
      render 'new'
    end

    if @user.save
      @senders = params[:senders].split("\r\n")

      @senders.each do |name|
        @sender = Sender.new
        @sender.name =  name
        @sender.user_id = @user.id
        if !@sender.save
          render 'new'
        end
      end

      jasmin_filter = JasminFilter.new()
      unless jasmin_filter.add_filter(@user.id, "UserFilter", @user.username)
        jasmin_delete_user = JasminUser.new()
        jasmin_delete_user.delete_user(user_params[:username])
        @user.delete
        render 'new'
        return
      end

      @filter = Filter.new(:fid => @user.id, :filter_type => "UserFilter", :parameter => @user.username)
      unless @filter.save
        jasmin_delete_user = JasminUser.new()
        jasmin_delete_user.delete_user(user_params[:username])
        jasmin_delete_filter = JasminFilter.new()
        jasmin_delete_filter.delete_filter(@user.id)
        @user.delete
        render 'new'
      end
      redirect_to reseller_users_path
    else
      jasmin_delete_user = JasminUser.new()
      jasmin_delete_user.delete_user(user_params[:username])
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    jasmin_user = JasminUser.new()
    unless jasmin_user.update_user(@user.username, user_params[:jasmin_password], user_params[:sms_count])
      render 'new'
    end
    if @user.update_attributes(:email => user_params[:email], :sms_count => user_params[:sms_count], :role => 0, :password =>user_params[:jasmin_password], :password_confirmation => user_params[:jasmin_password], :jasmin_password => user_params[:jasmin_password])
      Sender.where(:user_id => @user.id).delete_all
      @senders = params[:senders].split("\r\n")

      @senders.each do |name|
        @sender = Sender.new
        @sender.name =  name
        @sender.user_id = @user.id
        if !@sender.save
          render 'new'
        end
      end
      redirect_to reseller_users_path, :notice => "User updated."
    else
      redirect_to reseller_users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    @user = User.find(params[:id])

    jasmin_filter = JasminFilter.new()
    unless jasmin_filter.delete_filter(@user.id)
      redirect_to reseller_users_path, :notice => "Unable to delete user."
      return
    end
    @filter = Filter.where(fid: @user.id)
    @filter.destroy_all

    jasmin_user = JasminUser.new()
    unless jasmin_user.delete_user(@user.username)
      redirect_to reseller_users_path, :notice => "Unable to delete user."
      return
    end
    @user.destroy
    redirect_to reseller_users_path, :notice => "User deleted."
  end

  private

  def user_params
    params.require(:user).permit(
        :username,
        :email,
        :sms_count,
        :role,
        :password,
        :jasmin_password,
    )
  end
end
