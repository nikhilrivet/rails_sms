class ContactsController < BaseController
  def index
    @groups = Group.where(:user_id => current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @contact = Contact.new
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_back(fallback_location: authenticated_root_path)
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
    @contact = Contact.find(params[:id])
    @contact.destroy

    redirect_back(fallback_location: authenticated_root_path)
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :number, :group_id)
  end
end
