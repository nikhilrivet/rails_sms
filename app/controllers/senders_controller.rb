class SendersController < ApplicationController
  def index
    @senders = Sender.where(:user_id => current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @contact = Contact.new
    @contacts = Contact.where(:group_id => params[:id])
  end

  def new
    @sender = Sender.new
  end

  def edit
    @sender = Sender.find(params[:id])
  end

  def create
    @save_params = {
        name: sender_params["name"],
        user_id: current_user.id
    }
    @sender = Sender.new(@save_params)

    if @sender.save
      redirect_to senders_path
    else
      render 'new'
    end
  end

  def update
    @sender = Sender.find(params[:id])

    if @sender.update(sender_params)
      redirect_to senders_path
    else
      render 'edit'
    end
  end

  def destroy
    @sender = Sender.find(params[:id])
    @sender.destroy

    redirect_to senders_path
  end

  private
  def sender_params
    params.require(:sender).permit(:name)
  end
end
