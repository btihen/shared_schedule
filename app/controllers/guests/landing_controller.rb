class Guests::LandingController < Guests::AppController

  def index
    user          = current_user || GuestUser.new
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    tenant        = Tenant.landing_page(user) || user.tenant
    spaces        = Space.unscoped.viewable_by(user, tenant)

    user_view     = Guests::UserView.new(user)
    tenant_view   = Guests::TenantView.new(tenant)
    spaces_view   = Guests::SpaceView.collection(spaces)
    calendar_view = Guests::CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'guests/landing/index',
                            locals: { user_view: user_view,
                                      spaces_view: spaces_view,
                                      tenant_view: tenant_view,
                                      calendar_view: calendar_view } }
    end
  end

end
