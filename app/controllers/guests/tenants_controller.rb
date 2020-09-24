class Guests::TenantsController < Guests::AppController

  def index
    user          = current_user || GuestUser.new
    tenants       = Tenant.viewable_by(user) || user.tenant

    user_view     = Guests::UserView.new(user)
    tenants_views = Guests::TenantView.collection(tenants)

    respond_to do |format|
      format.html { render 'guests/tenants/index',
                            locals: {tenants_view: tenants_views} }
    end
  end

  def show
    user          = current_user || GuestUser.new
    tenant        = Tenant.find(params[:id])
    unauthorized_view(user, tenant); return if performed?

    spaces        = Space.viewable_by(user, tenant)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date

    user_view     = Guests::UserView.new(user)
    tenant_view   = Guests::TenantView.new(tenant)
    space_views   = Guests::SpaceView.collection(spaces)
    calendar_view = Guests::CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'guests/tenants/show',
                            locals: { user_view: user_view,
                                      tenant_view: tenant_view,
                                      spaces_view: space_views,
                                      calendar_view: calendar_view } }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def tenant_params
      params.require(:tenant).permit(:tenant_name)
    end
end
