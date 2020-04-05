class LandingController < ApplicationController

  def index
    user          = current_user || GuestUser.new
    date          = params[:date].nil? ? Date.today : params[:date].to_s.to_date
    tenant        = Tenant.find_by(tenant_name: "DemoGroup")
    tenant_view   = TenantView.new(tenant)
    spaces_view   = tenant_view.spaces
    user_view     = UserView.new(user)
    calendar_view = CalendarView.new(tenant_view, user_view, date)

    respond_to do |format|
      format.html { render 'landing/index', locals: { user: user_view,
                                                      spaces: spaces_view,
                                                      tenant: tenant_view,
                                                      calendar: calendar_view } }
    end
  end

end
