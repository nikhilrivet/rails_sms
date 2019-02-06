class DcontactsController < BaseController
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
    @distribution_id = params[:distribution_id]
    if params[:numbers]
      @numbers = params[:numbers].split("\r\n")
      if @numbers.uniq.length != @numbers.length
        flash[:danger] = "Dose not contain duplicate numbers"
        redirect_back(fallback_location: authenticated_root_path)
        return
      end
      @numbers.each do |number|
        unless is_numeric?number
          flash[:danger] = "Allow Numbers"
          redirect_back(fallback_location: authenticated_root_path)
          return
        end
        @dcontact = Dcontact.new
        @dcontact.number =  number
        @dcontact.distribution_id = @distribution_id
        if !@dcontact.save
          render 'new'
        end
      end
    end


=begin
    rowarray = Array.new
=end
    if params[:file]

      myfile = params[:file]

      if myfile.content_type != "text/plain" && myfile.content_type != "text/csv"
        flash[:danger] = "File Type is txt or csv"
        redirect_back(fallback_location: authenticated_root_path)
        return
      end

      @rowarraydisp = CSV.read(myfile.path)
      if @rowarraydisp.uniq.length != @rowarraydisp.length
        flash[:danger] = "Dose not contain duplicate numbers"
        redirect_back(fallback_location: authenticated_root_path)
        return
      end
      @rowarraydisp.each do |row|
        unless is_numeric?row.first
          flash[:danger] = "Allow Numbers"
          redirect_back(fallback_location: authenticated_root_path)
          return
        end
        @dcontact = Dcontact.new
        @dcontact.number =  row.first

        @dcontact.distribution_id = @distribution_id
        if !@dcontact.save
          render 'new'
        end
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
    @dcontact = Dcontact.find(params[:id])
    @dcontact.destroy

    redirect_back(fallback_location: authenticated_root_path)
  end

  def is_numeric?(obj)
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :number, :group_id)
  end
end
