class Admin::RoutersController < Admin::BaseController
def index
  @routers = Router.all
end

def show
  unless current_user.admin?
    unless @user == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end
  @user = User.find(params[:id])
  @routers = Router.where(user_id: params[:id])
  @router = Router.new
  @connectors = Connector.all
end

def new
  @router = Router.new
end

def edit
  @router = Router.find(params[:id])
end

def create
  @router = Router.new(:router_type => "StaticMTRoute", :rate => router_params[:rate], :connector => router_params[:connector], :filter => router_params[:user_id], :user_id => router_params[:user_id])
  if @router.save
    @router.update_attributes(:router_order => @router.id)

    jasmin_router = JasminRouter.new()
    unless jasmin_router.add_router(@router.router_order, @router[:router_type], @router[:rate], @router[:connector], @router[:filter])
      @router.delete
      redirect_back(fallback_location: authenticated_root_path)
      return
    end
    redirect_back(fallback_location: authenticated_root_path)
    return
  else
    redirect_back(fallback_location: authenticated_root_path)
    return
  end
end

def update
  @router = Router.find(params[:id])

  jasmin_router_add = JasminRouter.new()
  unless jasmin_router_add.add_router(router_params[:router_order], router_params[:router_type], router_params[:rate], router_params[:connector], router_params[:filter])
    redirect_to admin_routers_path, :alert => "Unable to update router."
    return
  end

  jasmin_router_del = JasminRouter.new()

  unless jasmin_router_del.delete_router(@router[:router_order])
    redirect_to admin_routers_path, :alert => "Unable to update router."
    return
  end
  if @router.update_attributes(router_params)
    redirect_to admin_routers_path, :notice => "Router updated."
  else
    redirect_to admin_routers_path, :alert => "Unable to update router."
  end
end

def destroy
  @router = Router.find(params[:id])
  jasmin_router = JasminRouter.new()
  unless jasmin_router.delete_router(@router.router_order)
    redirect_to admin_routers_path, :notice => "Unable to delete Router."
    return
  end
  @router.destroy
  redirect_back(fallback_location: authenticated_root_path)
end

private

def router_params
  params.require(:router).permit(
      :router_order,
      :router_type,
      :rate,
      :connector,
      :filter,
      :user_id
  )
end
end
