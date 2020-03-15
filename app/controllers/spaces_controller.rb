class SpacesController < ApplicationController

  # show mini-calendars for each space in Tenant
  def index
    user          = current_user || GuestUser.new
    space         = Space.find(params[:id])
    tenant        = Tenant.find(params[:tenant_id])
    unauthorized_change(user, tenant, space); return if performed?

    tenant_view   = TenantView.new(tenant)
    spaces        = tenant.spaces.all
    space_views   = SpaceView.collection(spaces)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    user_view     = UserView.new(user)
    respond_to do |format|
      # it tenant really needed?
      format.html { render 'spaces/index', locals: {user: user_view,
                                                    tenant: tenant_view,
                                                    spaces: space_views,
                                                    calendar: calendar_view} }
    end
  end

  # larger (but responsive) calendar for chosen space
  def show
    user          = current_user || GuestUser.new
    space         = Space.find(params[:id])
    tenant        = Tenant.find(params[:tenant_id])
    unauthorized_change(user, tenant, space); return if performed?

    # tenant_view   = TenantView.new(tenant)
    space_view    = SpaceView.new(space)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    calendar_view = CalendarView.new(date: date)
    user_view     = UserView.new(user)
    respond_to do |format|
      format.html { render 'spaces/show', locals: { user: user_view,
                                                    space: space_view,
                                                    today: Date.today} }
    end
  end

  # def edit
  # end

  # def update
  #   respond_to do |format|
  #     if @space.update(space_params)
  #       format.html { redirect_to @space, notice: 'Space was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @space }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @space.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def new
  #   space = Space.new
  #   # space_form = SpaceForm(spaces)
  #   # format.html { render 'space/new',
  #   #               locals: {space_view: space_form}
  #   #             }
  # end

  # def create
  #   @space = Space.new(space_params)
  #   # space_form = SpaceForm(space)
  #   respond_to do |format|
  #     if @space.save
  #       format.html { redirect_to @space, notice: 'Space was successfully created.' }
  #       format.json { render :show, status: :created, location: @space }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @space.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @space.destroy
  #   respond_to do |format|
  #     format.html { redirect_to spaces_url, notice: 'Space was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # def get_space
    #   Space.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def space_params
      params.require(:space).permit(:space_name, :time_zone, :space_location, :is_double_booking_ok, :tenant_id)
    end
end
