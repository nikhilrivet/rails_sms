class GroupsController < BaseController
  def index
    @groups = Group.where(:user_id => current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @contact = Contact.new
    @contacts = Contact.where(:group_id => params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @save_params = {
        name: group_params["name"],
        user_id: current_user.id
    }
    @group = Group.new(@save_params)

    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  def destroy
    @gruop = Group.find(params[:id])
    @gruop.destroy

    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end
end
