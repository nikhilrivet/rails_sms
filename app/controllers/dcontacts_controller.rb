class DcontactsController < ApplicationController
  require 'csv'

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

=begin
    rowarray = Array.new
=end
    myfile = params[:file]

    @rowarraydisp = CSV.read(myfile.path)
    @rowarraydisp.each do |row|
      @dcontact = Dcontact.new
      @dcontact.number =  row.first
      @dcontact.distribution_id = @distribution_id
      if !@dcontact.save
        render 'new'
      end
    end

=begin
    @filename = params[:file].read
    @filename.each_line do |line|
      line_to = line.to_s
      @dcontact = Dcontact.new
      @dcontact.number =  line_to
      @dcontact.distribution_id = @distribution_id
    end
=end
=begin
    @filename = params[:file].read
    if @filename.respond_to?(:read)
      @lines = @filename.read
      byebug
    elsif @filename.respond_to?(:path)
      @lines = File.read(@filename.path)
      byebug
    else
      logger.error "Bad file_data: #{@filename.class.name}: #
    {@filename.inspect}"
    end
=end

=begin
    @lines.each do |line|
      @dcontact = Dcontact.new
      @dcontact.number =  line
      @dcontact.distribution_id = @distribution_id
    end
=end

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
