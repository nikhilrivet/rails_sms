class Admin::FiltersController < Admin::BaseController
  def index
    @filters = Filter.all
  end

  def show
    @connector = Connector.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def new
    @filter = Filter.new
  end

  def edit
    @filter = Filter.find(params[:id])
  end

  def create
    @filter = Filter.new(filter_params)
    jasmin_filter = JasminFilter.new()
    unless jasmin_filter.add_filter(filter_params[:fid], filter_params[:filter_type], filter_params[:parameter])
      render 'new'
      return
    end
    if @filter.save
      redirect_to admin_filters_path
    else
      render 'new'
    end
  end

  def update
    @filter = Filter.find(params[:id])
    if @filter.update_attributes(filter_params)
      redirect_to admin_filters_path, :notice => "Filter updated."
    else
      redirect_to admin_filters_path, :alert => "Unable to update filter."
    end
  end

  def destroy
    @filter = Filter.find(params[:id])
    jasmin_filter = JasminFilter.new()
    unless jasmin_filter.delete_filter(@filter.fid)
      redirect_to admin_filters_path, :notice => "Unable to delete Filter."
      return
    end
    @filter.destroy
    redirect_to admin_filters_path, :notice => "Filter deleted."
  end

  private

  def filter_params
    params.require(:filter).permit(
        :fid,
        :filter_type,
        :parameter,
    )
  end
end
