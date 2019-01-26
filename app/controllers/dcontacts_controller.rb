class DcontactsController < ApplicationController
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
    @numbers = params[:numbers].split("\r\n")
    @distribution_id = params[:distribution_id]
    @numbers.each do |number|
      @dcontact = Dcontact.new
      @dcontact.number =  number
      @dcontact.distribution_id = @distribution_id
      if !@dcontact.save
        render 'new'
      end
    end

    @filename = params[:file]

    if @filename.respond_to?(:read)
      @lines = @filename.read
    elsif @filename.respond_to?(:path)
      @lines = File.read(@filename.path)
    else
      logger.error "Bad file_data: #{@filename.class.name}: #
    {@filename.inspect}"
    end

    redirect_back(fallback_location: authenticated_root_path)

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
