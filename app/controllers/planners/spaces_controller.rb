class Planners::SpacesController < Planners::AppController

  # # show mini-calendars for each space in Tenant
  # def index
  #   user          = current_user || GuestUser.new
  #   tenant        = Tenant.find(params[:tenant_id])
  #   unauthorized_view(user, tenant); return if performed?
  #
  #   spaces        = Space.viewable_by(user, tenant)
  #   date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date

  #   user_view     = Planners::UserView.new(user)
  #   tenant_view   = Planners::TenantView.new(tenant)
  #   space_views   = Planners::SpaceView.collection(spaces)
  #   calendar_view = Planners::CalendarView.new(tenant_view, user_view, date)
  #
  #   respond_to do |format|
  #     # is tenant really needed?
  #     format.html { render 'planners/spaces/index',
  #                           locals: { user_view: user_view,
  #                                     tenant_view: tenant_view,
  #                                     spaces_view: space_views,
  #                                     calendar_view: calendar_view } }
  #   end
  # end
  #
  # # # larger (but responsive) calendar for chosen space
  # # def show
  # #   user          = current_user || GuestUser.new
  # #   space         = Space.find(params[:id])
  # #   tenant        = Tenant.find(params[:tenant_id])
  # #   unauthorized_view(user, tenant, space); return if performed?
  #
  # #   date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date

  # #   # tenant_view   = Planners::TenantView.new(tenant)
  # #   space_view    = Planners::SpaceView.new(space)
  # #   calendar_view = Planners::CalendarView.new(tenant_view, user_view, date)
  # #   user_view     = Planners::UserView.new(user)

  # #   respond_to do |format|
  # #     format.html { render 'planners/spaces/show',
  # #                           locals: { user_view: user_view,
  # #                                     space_view: space_view,
  # #                                     today: Date.today } }
  # #   end
  # # end

  private
    # Only allow a list of trusted parameters through.
    def space_params
      params.require(:space).permit(:space_name, :time_zone, :space_location, :is_double_booking_ok, :tenant_id)
    end
end
