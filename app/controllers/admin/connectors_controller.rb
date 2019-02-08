class Admin::ConnectorsController < Admin::BaseController
  def index
    @connectors = Connector.all
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
    @connector = Connector.new
  end

  def edit
    @connector = Connector.find(params[:id])
  end

  def create
    @connector = Connector.new(connector_params)
    jasmin_connector = JasminConnector.new()
    unless jasmin_connector.add_smppccm(connector_params[:cid], connector_params[:host], connector_params[:port], connector_params[:username], connector_params[:password])
      render 'new'
    end
    if @connector.save
      jasmin_connector.start_smppccm(connector_params[:cid])
      redirect_to admin_connectors_path
    else
      render 'new'
    end
  end

  def update
    @connector = Connector.find(params[:id])
    if @connector.update_attributes(connector_params)
      redirect_to admin_connectors_path, :notice => "Connector updated."
    else
      redirect_to admin_connectors_path, :alert => "Unable to update connector."
    end
  end

  def destroy
    @connector = Connector.find(params[:id])
    jasmin_connector = JasminConnector.new()
    unless jasmin_connector.delete_smppccm(@connector.cid)
      redirect_to admin_connectors_path, :notice => "Unable to delete connector."
      return
    end
    @connector.destroy
    redirect_to admin_connectors_path, :notice => "Connector deleted."
  end

  private

  def connector_params
    params.require(:connector).permit(
        :cid,
        :host,
        :port,
        :username,
        :password,
    )
  end
end
