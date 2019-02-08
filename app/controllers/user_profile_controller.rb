class UserProfileController < ApplicationController
  def index
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    unless user_params['password'] == user_params['password_confirmation']
      redirect_to user_profile_index_path, :notice => "Password no match."
    end

    if @user.update_attributes(user_params)
      redirect_to destroy_user_session_path, :notice => "User updated."
    else
      redirect_to user_profile_index_path, :alert => "Unable to update user."
    end
  end

  private

  def user_params
    params.require(:user).permit(
        :email,
        :phone,
        :company,
        :password,
        :password_confirmation,
    )
  end
end
