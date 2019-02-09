class Reseller::DistributionsController < Reseller::BaseController
  def index
    @distributions = Distribution.where(:user_id => current_user.id)
  end

  def show
    @distribution = Distribution.find(params[:id])
    @dcontact = Dcontact.new
    @dcontacts = Dcontact.where(:distribution_id => params[:id])
  end

  def new
    @distribution = Distribution.new
  end

  def edit
    @distribution = Distribution.find(params[:id])
  end

  def create
    @save_params = {
        name: distribution_params["name"],
        user_id: current_user.id
    }
    @distribution = Distribution.new(@save_params)

    if @distribution.save
      redirect_to distributions_path
    else
      render 'new'
    end
  end

  def update
    @distribution = Distribution.find(params[:id])

    if @distribution.update(distribution_params)
      redirect_to distributions_path
    else
      render 'edit'
    end
  end

  def destroy
    @distribution = Distribution.find(params[:id])
    @distribution.destroy

    redirect_to distributions_path
  end

  private
  def distribution_params
    params.require(:distribution).permit(:name)
  end
end
