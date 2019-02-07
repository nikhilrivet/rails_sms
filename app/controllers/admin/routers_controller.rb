class Admin::RoutersController < Admin::BaseController
def index
  @routers = Router.all
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
  @router = Router.new
end

def edit
  @router = Router.find(params[:id])
end

def create
  jasmin_router = JasminRouter.new()
  jasmin_router.add_router(router_params[:router_order], router_params[:router_type], router_params[:rate], router_params[:connector])
  @router = Router.new(router_params)
  if @router.save
    redirect_to admin_routers_path
  else
    render 'new'
  end
end

def update
  @router = Router.find(params[:id])
  if @router.update_attributes(router_params)
    redirect_to admin_routers_path, :notice => "Router updated."
  else
    redirect_to admin_routers_path, :alert => "Unable to update router."
  end
end

def destroy
  @router = Router.find(params[:id])
  @router.destroy
  redirect_to admin_routers_path, :notice => "Router deleted."
end

private

def router_params
  params.require(:router).permit(
      :router_order,
      :router_type,
      :rate,
      :connector,
      :filter,
  )
end
end
