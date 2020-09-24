class Guests::SpacesController < Guests::AppController

  # show mini-calendars for each space in Tenant
  def index
    user          = current_user || GuestUser.new
    tenant        = Tenant.find(params[:tenant_id])
    unauthorized_view(user, tenant); return if performed?

    spaces        = Space.viewable_by(user, tenant)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date

    user_view     = Guests::UserView.new(user)
    tenant_view   = Guests::TenantView.new(tenant)
    space_views   = Guests::SpaceView.collection(spaces)
    calendar_view = Guests::CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      # is tenant really needed?
      format.html { render 'guests/spaces/index',
                            locals: { user_view: user_view,
                                      tenant_view: tenant_view,
                                      spaces_view: space_views,
                                      calendar_view: calendar_view } }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def space_params
      params.require(:space).permit(:space_name, :time_zone, :space_location, :is_double_booking_ok, :tenant_id)
    end
end
