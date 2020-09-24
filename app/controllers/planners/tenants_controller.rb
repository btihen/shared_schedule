class Planners::TenantsController < Planners::AppController

  def index
    user          = current_user
    tenant        = user.tenant
    unauthorized_view(user, tenant); return if performed?

    spaces        = Space.viewable_by(user, tenant)
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date

    user_view     = Planners::UserView.new(user)
    tenant_view   = Planners::TenantView.new(tenant)
    space_views   = Planners::SpaceView.collection(spaces)
    calendar_view = Planners::CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'planners/tenants/show',
                            locals: { user_view: user_view,
                                      tenant_view: tenant_view,
                                      spaces_view: space_views,
                                      calendar_view: calendar_view } }
    end
  end

  # private
  #   # Only allow a list of trusted parameters through.
  #   def tenant_params
  #     params.require(:tenant).permit(:tenant_name)
  #   end
end
